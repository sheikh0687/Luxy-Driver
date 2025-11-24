//
//  MapView.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 06/06/24.
//

import Foundation
import MapKit

extension ArrivedVC: MKMapViewDelegate {
    
    // MKMapViewDelegate method to customize overlays (polylines)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [ hexStringToUIColor(hex: "#000000"), hexStringToUIColor(hex: "#000000")]
        
        /// Initialise a GradientPathRenderer with the colors
        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        
        /// set a linewidth
        polylineRenderer.lineWidth = 7
        return polylineRenderer
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let identifier = "CustomViewAnnotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        let cc = annotation as! CustomPointAnnotation
        anView?.image = UIImage.init(named: cc.imageName ?? "")
        
        if let annotationView = anView {
            let rotationAngle = CGFloat(cc.bearing * .pi / 180.0) // Degrees to radians
            annotationView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
        
        return anView
    }
}

extension HomeVC: MKMapViewDelegate {
    
    // MKMapViewDelegate method to customize overlays (polylines)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [ hexStringToUIColor(hex: "#000000"), hexStringToUIColor(hex: "#000000")]
        
        /// Initialise a GradientPathRenderer with the colors
        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        
        /// set a linewidth
        polylineRenderer.lineWidth = 7
        return polylineRenderer
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let identifier = "CustomViewAnnotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        let cc = annotation as! CustomPointAnnotation
        anView?.image = UIImage.init(named: cc.imageName ?? "")
        
        return anView
    }
}

extension RideDetailVC: MKMapViewDelegate {
    
    // MKMapViewDelegate method to customize overlays (polylines)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [ hexStringToUIColor(hex: "#000000"), hexStringToUIColor(hex: "#000000")]
        
        /// Initialise a GradientPathRenderer with the colors
        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        
        /// set a linewidth
        polylineRenderer.lineWidth = 7
        return polylineRenderer
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let identifier = "CustomViewAnnotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        let cc = annotation as! CustomPointAnnotation
        anView?.image = UIImage.init(named: cc.imageName ?? "")
        
        return anView
    }
}
