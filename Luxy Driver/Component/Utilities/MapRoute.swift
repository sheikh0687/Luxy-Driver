//
//  MapRoute.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 06/06/24.
//

import Foundation
import MapKit

var currentRoute: MKRoute?

func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, waypoints: [CLLocationCoordinate2D], mapView: MKMapView,_ obj: ResActiveReq) {
    
    mapView.removeOverlays(mapView.overlays)
    
    var allLocations: [CLLocationCoordinate2D]?
    
    if let currentStatus = obj.status {
        if currentStatus == "Arrived" {
            if let user_request_stop = obj.user_request_stop {
                if user_request_stop.count > 0 {
                    allLocations = [source] + waypoints
                } else {
                    allLocations = [source] + waypoints + [destination]
                }
            } else {
                allLocations = [source] + waypoints + [destination]
            }
        } else if currentStatus == "Start" {
            if let user_request_stop = obj.user_request_stop {
                if user_request_stop.count > 0 {
                    for val in user_request_stop {
                        if val.status == "Pending" || val.status == "Waiting_Time_Start" {
                            allLocations = [source] + waypoints
                        } else {
                            allLocations = [source] + [destination]
                        }
                    }
                } else {
                    allLocations = [source] + waypoints + [destination]
                }
            } else {
                allLocations = [source] + waypoints + [destination]
            }
        } else {
            allLocations = [source] + waypoints + [destination]
        }
    }
    
    //    allLocations = [source] + waypoints + [destination]
    
    let dispatchGroup = DispatchGroup()
    
    for i in 0..<((allLocations?.count ?? 0) - 1) {
        guard let source = allLocations?[i] else { return }
        guard let destination = allLocations?[i + 1] else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        dispatchGroup.enter()
        directions.calculate { (response, error) in
            defer { dispatchGroup.leave() }
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error calculating route: \(error.localizedDescription)")
                }
                return
            }
            currentRoute = route
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    // Adjust map region once all routes are calculated
    dispatchGroup.notify(queue: .main) {
        var mapRect = MKMapRect.null
        for overlay in mapView.overlays {
            if let polyline = overlay as? MKPolyline {
                mapRect = mapRect.union(polyline.boundingMapRect)
            }
        }
        mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}

func isDriverOnRoute(driverLocation: CLLocationCoordinate2D, route: MKRoute) -> Bool {
    guard let polyline = route.polyline as? MKPolyline else { return false }
    
    // Convert the polyline to an array of points
    let routePoints = polyline.points()
    let pointCount = polyline.pointCount
    
    var closestDistance: CLLocationDistance = Double.greatestFiniteMagnitude
    
    // Iterate through route points to find the closest distance
    for i in 0..<pointCount {
        let point = routePoints[i]
        let routeCoordinate = point.coordinate
        let location = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let routeLocation = CLLocation(latitude: routeCoordinate.latitude, longitude: routeCoordinate.longitude)
        let distance = location.distance(from: routeLocation)
        
        closestDistance = min(closestDistance, distance)
    }
    
    // Check if the closest distance is within 30 meters
    print("Closest distance to route: \(closestDistance) meters")
    return closestDistance <= 30.0
}

func moveDriverMarker(to newLocation: CLLocationCoordinate2D, withBearing newBearing: Double, mapView: MKMapView) {
    // Update annotation's position and bearing
    let customAnnotation = CustomPointAnnotation()
    customAnnotation.coordinate = newLocation
    customAnnotation.bearing = newBearing

    // Animate marker movement and rotation
    if let annotationView = mapView.view(for: customAnnotation) {
        let rotationAngle = CGFloat(newBearing * .pi / 180.0) // Convert degrees to radians
        
        UIView.animate(withDuration: 1.0) { // Smooth animation for movement and rotation
            annotationView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            annotationView.annotation = customAnnotation // Update position
        }
    }
}

func animateMarkerAlongPath(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, duration: TimeInterval, mapView: MKMapView) {
    let deltaLat = (end.latitude - start.latitude) / 100
    let deltaLon = (end.longitude - start.longitude) / 100
    
    var currentLat = start.latitude
    var currentLon = start.longitude
    
    Timer.scheduledTimer(withTimeInterval: duration / 100, repeats: true) { timer in
        currentLat += deltaLat
        currentLon += deltaLon
        
        let intermediateLocation = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLon)
        moveDriverMarker(to: intermediateLocation, withBearing: calculateBearing(from: start, to: end), mapView: mapView)
        
        if abs(currentLat - end.latitude) < abs(deltaLat) && abs(currentLon - end.longitude) < abs(deltaLon) {
            timer.invalidate() // Stop animation when destination is reached
        }
    }
}

func calculateBearing(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
    let deltaLon = end.longitude - start.longitude
    let y = sin(deltaLon) * cos(end.latitude)
    let x = cos(start.latitude) * sin(end.latitude) - sin(start.latitude) * cos(end.latitude) * cos(deltaLon)
    let bearing = atan2(y, x) * 180 / .pi
    return (bearing >= 0) ? bearing : (bearing + 360) // Ensure positive angle
}

func calculateRouteForDetailsRide(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, waypoints: [CLLocationCoordinate2D], mapView: MKMapView) {
    
    mapView.removeOverlays(mapView.overlays)
    
    var allLocations: [CLLocationCoordinate2D]?
    
    allLocations = [source] + waypoints + [destination]
    
    let dispatchGroup = DispatchGroup()
    
    for i in 0..<((allLocations?.count ?? 0) - 1) {
        guard let source = allLocations?[i] else { return }
        guard let destination = allLocations?[i + 1] else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        dispatchGroup.enter()
        directions.calculate { (response, error) in
            defer { dispatchGroup.leave() }
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error calculating route: \(error.localizedDescription)")
                }
                return
            }
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    // Adjust map region once all routes are calculated
    dispatchGroup.notify(queue: .main) {
        var mapRect = MKMapRect.null
        for overlay in mapView.overlays {
            if let polyline = overlay as? MKPolyline {
                mapRect = mapRect.union(polyline.boundingMapRect)
            }
        }
        mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}
