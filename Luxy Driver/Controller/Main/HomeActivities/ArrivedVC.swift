//
//  ArrivedVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit
import MapKit

class ArrivedVC: UIViewController {
    
    @IBOutlet weak var stop_TableVw: UITableView!
    @IBOutlet weak var stop_TableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var details_Vw: UIView!
    @IBOutlet weak var driver_Img: UIImageView!
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var progressUpperVw: UIView!
    @IBOutlet weak var gestureView: MTSlideToOpenView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dropPickText: UILabel!
    @IBOutlet weak var dropPickAddressText: UILabel!
    @IBOutlet weak var dropPickPinImg: UIImageView!
    
    @IBOutlet weak var lbl_MinutesMile: UILabel!
    
    @IBOutlet weak var lbl_DriverName: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var lbl_DriverAmount: UILabel!
    @IBOutlet weak var lbl_ProgressTime: UILabel!
    @IBOutlet weak var lbl_WaitingCharge: UILabel!
    
    var receiverId = ""
    var requestId = ""
    var rewardPoints = ""
    var stop_RequestiD = ""
    
    var driverCurrentStatus = ""
    
    var dropLat: String = ""
    var dropLon: String = ""
    
    var pickLat: String = ""
    var pickLon: String = ""
    
    var timer: Timer?
    
    var safetyFee:String = ""
    var airportFee:String = ""
    
    var totalAmount:String = ""
    var totalWaitingAmount:String = ""
    var totalWaitingTime:String = ""
    var totalWaitingDriverAmount:String = ""
    
    var stopTotalWaitingTime:String = ""
    var stopWaitingAmount:String = ""
    
    var adminCommissionAmount:String = ""
    var driverCommissionAmount:String = ""
    
    var driverLevel:String = ""
    var driverSubAmount:String = ""
    
    var pickupAnnotation: CustomPointAnnotation?
    var arrayOfAddReq: [User_request_stop] = []
    
    var driverLocation: CLLocationCoordinate2D!
    var dropOffLocation: CLLocationCoordinate2D!
    var stopLocation: [CLLocationCoordinate2D]!
    
    var isCalled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.stop_TableVw.register(UINib(nibName: "UserStopCell", bundle: nil), forCellReuseIdentifier: "UserStopCell")
        self.mapView.delegate = self
        self.swipeGesture()
        self.checkDriverLocation()
        self.updateLocationAtAwayTime()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func swipeGesture()
    {
        gestureView.thumnailImageView.image = R.image.leftToRight()
        gestureView.thumbnailColor = .clear
        gestureView.slidingColor = .clear
        gestureView.textColor = UIColor.white
        gestureView.labelText = "Notify Arrived"
        gestureView.sliderBackgroundColor = .clear
        gestureView.delegate = self
    }
    
    @objc func clickAction() {
        details_Vw.isHidden = true
    }
    
    func checkDriverLocation() {
        print("checkDriverLocation called")
        
        timer?.invalidate()
        print("Existing timer invalidated")
        
        timer = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(startCounter), userInfo: nil, repeats: true)
        
        if timer != nil {
            print("Timer successfully created")
        } else {
            print("Failed to create timer")
        }
    }
    
    @objc func startCounter() {
        print("Timer fired at \(Date())")
        self.updateLocationAtAwayTime()
    }
    
    @IBAction func btnback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Chat(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.receiverId = self.receiverId
        vc.requestId = self.requestId
        //        vc.userName = self.lblUserName.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Edit(_ sender: UIButton) {
        details_Vw.isHidden = false
    }
    
    @IBAction func btn_RideDetails(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "RideDetailVC") as! RideDetailVC
        vC.request_iD = self.requestId
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func btn_CancelRide(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "PresentCancelVC") as! PresentCancelVC
         vC.cloCancelReason = { [weak self] in
             guard let self = self else { return }
             vC.dismiss(animated: true) { // Dismiss PresentCancelVC first
                 let viewCancel = R.storyboard.main().instantiateViewController(withIdentifier: "PresentCancelReasonVC") as! PresentCancelReasonVC
                 viewCancel.modalTransitionStyle = .crossDissolve
                 viewCancel.modalPresentationStyle = .overFullScreen
                 self.present(viewCancel, animated: true)
             }
         }
         vC.modalTransitionStyle = .crossDissolve
         vC.modalPresentationStyle = .overFullScreen
         self.present(vC, animated: true)
         details_Vw.isHidden = true
    }
    
    @IBAction func btn_Navigate(_ sender: UIButton) {
        Utility.openGoogleMaps(latitude: Double(kAppDelegate.CURRENT_LAT) ?? 0.0, longitude: Double(kAppDelegate.CURRENT_LON) ?? 0.0)
    }
}

extension ArrivedVC {
    
    func updateLocationAtAwayTime()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["lat"] = kAppDelegate.CURRENT_LAT as AnyObject
        paramDict["lon"] = kAppDelegate.CURRENT_LON as AnyObject
        switch driverCurrentStatus {
        case "Arrived":
            paramDict["lat1"] = pickLat as AnyObject
            paramDict["lon1"] = pickLon as AnyObject
        default:
            paramDict["lat1"] = dropLat as AnyObject
            paramDict["lon1"] = dropLon as AnyObject
        }
        
        print(paramDict)
        
        Api.shared.update_LocationWithAwayTime(self, paramDict) { responseData in
            let obj = responseData
            if obj.status == "1" {
                self.lbl_MinutesMile.text = "\(obj.time_away ?? "") minutes, \(obj.distance_away ?? "") miles"
                self.driverLocation = CLLocationCoordinate2D(latitude: Double(kAppDelegate.CURRENT_LAT) ?? 0.0, longitude: Double(kAppDelegate.CURRENT_LON) ?? 0.0)
                
                if let route = currentRoute, !isDriverOnRoute(driverLocation: self.driverLocation, route: route) {
                    print("Driver is off the route. Recalculating...")
                    
                    // Recalculate route from the driver's current location
                    if self.isCalled {
                        calculateRouteForDetailsRide(from: self.driverLocation, to: self.dropOffLocation, waypoints: self.stopLocation, mapView: self.mapView)
                        animateMarkerAlongPath(from: self.driverLocation, to: self.dropOffLocation, duration: 0.5, mapView: self.mapView)
                    } else {
                        print("Called without")
                    }
                } else {
                    print("Driver is on the correct route.")
                }
            } else {
                print(obj.message ?? "")
            }
            self.updateCarMarker()
        }
     }
    
    func updateCarMarker()
    {
        let pickUpCoordinate = CLLocationCoordinate2D(latitude: Double(kAppDelegate.CURRENT_LAT) ?? 0.0, longitude: Double(kAppDelegate.CURRENT_LON) ?? 0.0)
        
        if let existingAnnotation = pickupAnnotation {
            existingAnnotation.coordinate = pickUpCoordinate
        } else {
            let newAnnotation = CustomPointAnnotation()
            newAnnotation.coordinate = pickUpCoordinate
            newAnnotation.title = ""
            newAnnotation.bearing = 90.0
            newAnnotation.imageName = "car_marker"
            
            mapView.addAnnotation(newAnnotation)
            pickupAnnotation = newAnnotation
        }
    }

    
    func confirm_Stop(_ statuss: String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        dict["user_id"]                = self.receiverId as AnyObject
        dict["request_id"]             = self.requestId as AnyObject
        dict["request_stop_id"]        = stop_RequestiD as AnyObject
        dict["status"]                 = statuss as AnyObject
        
        print(dict)
        
        Api.shared.add_Confirm_Stop(self, dict) { responseData in
            self.activeRequest()
        }
    }
    
    func activeRequest() {
        
        Api.shared.getActiveDriverReq(self) { responseData in
            self.updateReceiverDetails(responseData)
            self.updateRideStatus(responseData)
            
            if responseData.status == "Reject" {
                Switcher.updateRootVC()
            }
        }
    }
    
    private func updateReceiverDetails(_ obj: ResActiveReq) {
        self.receiverId = obj.user_id ?? ""
        self.requestId = obj.id ?? ""
        self.driverCurrentStatus = obj.status ?? ""
        self.rewardPoints = obj.user_details?.points ?? ""
        
        self.pickLat = obj.pickup_lat ?? ""
        self.pickLon = obj.pickup_lon ?? ""
        
        self.dropLat = obj.dropoff_lat ?? ""
        self.dropLon = obj.dropoff_lon ?? ""
        
        if obj.book_for_others == "Yes" {
            self.lbl_DriverName.text! = "\(obj.guest_name ?? "") (Guest)"
            self.driver_Img.image = R.image.profile_ic()
        } else {
            self.lbl_DriverName.text! = "\(obj.user_details?.first_name ?? "")"
            if Router.BASE_IMAGE_URL != obj.user_details?.image {
                Utility.setImageWithSDWebImage(obj.user_details?.image ?? "", self.driver_Img)
            } else {
                self.driver_Img.image = R.image.profile_ic()
            }
        }
        
        self.lbl_Rating.text! = "\(obj.rating ?? "") (\(obj.rating_count ?? ""))"
        self.lbl_DriverAmount.text! = "\(k.currency)\(obj.driver_amount ?? "")\n Estimate"
        
        self.dropPickText.text = "Pickup Address"
        self.dropPickAddressText.text = obj.pick_address ?? ""
        self.dropPickPinImg.image = R.image.loc_green_border_ic()
    }
    
    private func updateRideStatus(_ obj: ResActiveReq) {
        switch self.driverCurrentStatus {
        case "Accept":
            self.gestureView.labelText = "Notify Arrived"
            self.updateMapAnnotationsAndRoute(obj)
        case "Drive Now":
            self.gestureView.labelText = "Notify Arrived"
            self.updateMapAnnotationsAndRoute(obj)
        case "Arrived":
            self.gestureView.labelText = "Start Pickup"
            self.dropPickText.text = "Drop off"
            self.dropPickAddressText.text = obj.drop_address ?? ""
            self.dropPickPinImg.image = R.image.loc_red_border_ic()
            
            if let userRequestStop = obj.user_request_stop, !userRequestStop.isEmpty {
                for stop in userRequestStop {
                    if stop.status == "Pending" || stop.status == "Waiting_Time_Start" {
                        self.dropPickAddressText.text = stop.stop_address ?? ""
                        self.dropPickText.text = "Stop point"
                        break
                    }
                }
            }
            
            if let toLongTime = obj.to_long_time,
               let timerFreeMinute = Int(obj.timer_free_minute ?? "0"),
               let noShowFeeTime = obj.no_show_fee_time  {
                
                let totalElapsedTime = TimeInterval(toLongTime)
                let freeTimeInSeconds = TimeInterval(timerFreeMinute * 60)
                let noShowFeeTimeInterval = TimeInterval(noShowFeeTime)
                
                self.startTimer(totalElapsedTime: totalElapsedTime,
                                freeTime: freeTimeInSeconds,
                                noShowFeeTime: noShowFeeTimeInterval)
            }
            self.updateMapAnnotationsAndRoute(obj)
        case "Start":
            progressUpperVw.isHidden = true
            circularProgressView.isHidden = true
            self.gestureView.labelText = "Finish Ride"
            self.dropPickText.text = "Drop off"
            self.dropPickAddressText.text = obj.drop_address ?? ""
            self.dropPickPinImg.image = R.image.loc_red_border_ic()
            
            if let userRequestStop = obj.user_request_stop, !userRequestStop.isEmpty {
                for stop in userRequestStop {
                    if stop.status == "Pending" || stop.status == "Waiting_Time_Start" {
                        self.gestureView.labelText = "Confirm Stop"
                        self.dropPickAddressText.text = stop.stop_address ?? ""
                        self.dropPickText.text = "Stop point"
                        self.stop_RequestiD = stop.id ?? ""
                                                
                        if stop.status == "Waiting_Time_Start" {
                            self.gestureView.labelText = "Move Next"
                        }
                        break
                    }
                }
            }
            
            self.configureUserAddRequest(obj_Result: obj)
            self.updateMapAnnotationsAndRoute(obj)
        default:
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            vc.user_Id = self.receiverId
            vc.request_Id = self.requestId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func configureUserAddRequest(obj_Result: ResActiveReq)
    {
        if let res_AddResquest = obj_Result.user_request_stop {            
            for val in res_AddResquest {
                if val.status == "Waiting_Time_Start" {
                    if let toLongTime = val.to_long_time,
                       let timerFreeMinute = Int(val.stop_Timer_Free_Minute ?? "0"),
                       let noShowFeeTime = obj_Result.no_show_fee_time  {
                        
                        let totalElapsedTime = TimeInterval(toLongTime)
                        let freeTimeInSeconds = TimeInterval(timerFreeMinute * 60)
                        let noShowFeeTimeInterval = TimeInterval(noShowFeeTime)
                        
                        self.startTimer(totalElapsedTime: totalElapsedTime,
                                        freeTime: freeTimeInSeconds,
                                        noShowFeeTime: noShowFeeTimeInterval)
                    }
                } else if val.status == "Waiting_Time_End" {
                    circularProgressView.isHidden = true
                    progressUpperVw.isHidden = true
                    timer?.invalidate()
                } else {
                    circularProgressView.isHidden = true
                    progressUpperVw.isHidden = true
                    timer?.invalidate()
                }
            }
        }
    }
    
    private func startTimer(totalElapsedTime: TimeInterval, freeTime: TimeInterval, noShowFeeTime: TimeInterval) {
        progressUpperVw.isHidden = false
        circularProgressView.isHidden = false
        circularProgressView.setTrackColor = .lightGray
        circularProgressView.setProgressColor = .green
        
        var elapsedTime = totalElapsedTime // Start with the provided elapsed time.
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            elapsedTime += 1 // Increment the elapsed time by 1 second.
            let progress = min(Float(elapsedTime / noShowFeeTime), 1.0)
            
            // Update circular progress view.
            self.circularProgressView.setProgressWithAnimation(duration: 0.5, value: progress)
            
            // Update the timer label dynamically.
            self.lbl_ProgressTime.text = self.formatTime(elapsedTime)
            
            // Change the color of the circular progress if it exceeds free time.
            if elapsedTime > freeTime {
                self.circularProgressView.setProgressColor = .red
                self.lbl_WaitingCharge.isHidden = false
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
        
    private func updateMapAnnotationsAndRoute(_ obj: ResActiveReq) {
        self.isCalled = true
        let pickupCoordinate = CLLocationCoordinate2D (
            latitude: Double(obj.pickup_lat ?? "") ?? 0.0,
            longitude: Double(obj.pickup_lon ?? "") ?? 0.0
        )
        
        self.dropOffLocation = CLLocationCoordinate2D(
            latitude: Double(obj.dropoff_lat ?? "") ?? 0.0,
            longitude: Double(obj.dropoff_lon ?? "") ?? 0.0
        )
        
        var annotations = createPickupAndDropoffAnnotations(pickupCoordinate, dropOffLocation)
        self.stopLocation = createStopCoordinates(obj)
        
        annotations.append(contentsOf: createStopAnnotations(stopLocation))
        
        self.mapView.addAnnotations(annotations)
        if obj.status == "Accept" || obj.status == "Drive Now" {
            calculateRoute(from: pickupCoordinate, to: driverLocation, waypoints: stopLocation, mapView: self.mapView, obj)
        } else {
            calculateRoute(from: pickupCoordinate, to: dropOffLocation, waypoints: stopLocation, mapView: self.mapView, obj)
        }
     
        animateMarkerAlongPath(from: pickupCoordinate, to: dropOffLocation, duration: 0.5, mapView: self.mapView)
    }
    
    private func createPickupAndDropoffAnnotations(_ pickupCoordinate: CLLocationCoordinate2D, _ dropoffCoordinate: CLLocationCoordinate2D) -> [CustomPointAnnotation] {
        let pickupAnnotation = CustomPointAnnotation()
        pickupAnnotation.coordinate = pickupCoordinate
        pickupAnnotation.imageName = "pick_map_ic"
        pickupAnnotation.bearing = 90.0
        
        let dropoffAnnotation = CustomPointAnnotation()
        dropoffAnnotation.coordinate = dropoffCoordinate
        dropoffAnnotation.imageName = "drop_map_ic"
        dropoffAnnotation.bearing = 90.0
        
        return [pickupAnnotation, dropoffAnnotation]
    }
    
    private func createStopCoordinates(_ obj: ResActiveReq) -> [CLLocationCoordinate2D] {
        var stopCoordinates: [CLLocationCoordinate2D] = []
        
        for val in obj.user_request_stop ?? [] {
            if let lat = Double(val.stop_lat ?? ""), let lon = Double(val.stop_lon ?? "") {
                stopCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
        }
        
        return stopCoordinates
    }
    
    private func createStopAnnotations(_ stopCoordinates: [CLLocationCoordinate2D]) -> [CustomPointAnnotation] {
        return stopCoordinates.map { coordinate in
            let stopAnnotation = CustomPointAnnotation()
            stopAnnotation.coordinate = coordinate
            stopAnnotation.imageName = "AddStop"
            return stopAnnotation
        }
    }
}

extension ArrivedVC {
    
    func updateDriverStatus(_ whatsStatus: String)
    {
        var dict: [String : AnyObject] = [:]
        if driverCurrentStatus != "Start" {
            dict["driver_id"]                     = k.userDefault.value(forKey: k.session.userId) as AnyObject
            dict["request_id"]                    = self.requestId as AnyObject
            dict["lat"]                           = kAppDelegate.CURRENT_LAT as AnyObject
            dict["lon"]                           = kAppDelegate.CURRENT_LON as AnyObject
            dict["status"]                        = whatsStatus as AnyObject
        } else {
            dict["driver_id"]                     = k.userDefault.value(forKey: k.session.userId) as AnyObject
            dict["request_id"]                    = self.requestId as AnyObject
            dict["lat"]                           = kAppDelegate.CURRENT_LAT as AnyObject
            dict["lon"]                           = kAppDelegate.CURRENT_LON as AnyObject
            dict["status"]                        = whatsStatus as AnyObject
            
            dict["reason_detail"]                 = k.emptyString as AnyObject
            dict["reason_title"]                  = k.emptyString as AnyObject
            
            dict["safety_fee"]                    = safetyFee as AnyObject
            dict["airport_fee"]                   = airportFee as AnyObject
            
            dict["total_amount"]                  = totalAmount as AnyObject
            dict["total_waiting_amount"]          = totalWaitingAmount as AnyObject
            
            dict["total_waiting_time"]            = totalWaitingTime as AnyObject
            dict["stop_total_waiting_time"]       = stopTotalWaitingTime as AnyObject
            dict["stop_waiting_amount"]           = stopWaitingAmount as AnyObject
            
            dict["admin_comi_amount"]             = adminCommissionAmount as AnyObject
            dict["driver_comi_amount"]            = driverCommissionAmount as AnyObject
            
            dict["driver_level"]                  = driverLevel as AnyObject
            dict["total_waiting_driver_amount"]   = totalWaitingDriverAmount as AnyObject
            dict["driver_sub_amount"]             = driverSubAmount as AnyObject
        }
        
        print(dict)
        
        Api.shared.updateDriverStatus(self, dict) { responseData in
            print(responseData)
            if responseData.status != "Finish" {
                self.activeRequest()
            } else {
                let vc = R.storyboard.main().instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                vc.user_Id = self.receiverId
                vc.request_Id = self.requestId
                vc.isFrom = "RideFinish"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func fetchFinalFareCalculation()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["request_id"] = self.requestId as AnyObject
        paramDict["use_point"] = rewardPoints as AnyObject
        
        print(paramDict)
        
        Api.shared.requestToFinalCalculation(self, paramDict) { responseData in
            let obj = responseData
            if obj.status == "1" {
                self.safetyFee = obj.safety_fee ?? ""
                self.airportFee = obj.airport_fee ?? ""
                
                self.totalAmount = obj.total_fair_amount ?? ""
                self.totalWaitingAmount = obj.total_waiting_amount ?? ""
                
                self.totalWaitingTime = obj.total_waiting_time ?? ""
                self.stopTotalWaitingTime = obj.stop_total_waiting_time ?? ""
                self.stopWaitingAmount = obj.stop_waiting_amount ?? ""
                
                self.adminCommissionAmount = obj.admin_comi_amount ?? ""
                self.driverCommissionAmount = obj.driver_comi_amount ?? ""
                
                self.driverLevel = obj.driver_level ?? ""
                self.totalWaitingDriverAmount = obj.total_waiting_driver_amount ?? ""
                self.driverSubAmount = obj.driver_sub_amount ?? ""
                
                self.updateDriverStatus("Finish")
            } else {
                print(obj.message ?? "")
            }
        }
    }
    
    // Just Hide For the time being
//    func UpdateRequestTime()
//    {
//        var param: [String : AnyObject] = [:]
//        param["user_id"] = user_ID as AnyObject
//        param["request_id"] = requestId as AnyObject
//        
//        print(param)
//        
//        Api.shared.update_RequestTimer(self, param) { responseData in
//            self.activeRequest()
//        }
//    }
}

extension ArrivedVC: MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        switch driverCurrentStatus {
        case "Accept":
            self.updateDriverStatus("Arrived")
            sender.resetStateWithAnimation(true)
        case "Drive Now":
            self.updateDriverStatus("Arrived")
            sender.resetStateWithAnimation(true)
        case "Arrived":
            self.updateDriverStatus("Start")
            sender.resetStateWithAnimation(true)
        case "Start":
            print(self.gestureView.labelText)
            if self.gestureView.labelText == "Confirm Stop" {
                self.confirm_Stop("Waiting_Time_Start")
                sender.resetStateWithAnimation(true)
            } else if self.gestureView.labelText == "Move Next" {
                self.confirm_Stop("Waiting_Time_End")
                sender.resetStateWithAnimation(true)
            } else {
                fetchFinalFareCalculation()
            }
        default:
            break
        }
    }
}
