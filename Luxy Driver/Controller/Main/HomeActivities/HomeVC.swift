//
//  HomeVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit
import SlideMenuControllerSwift
import MapKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableViewOt: UITableView!
    
    @IBOutlet weak var lblOverAllEarning: UILabel!
    @IBOutlet weak var textDriverStatus: UILabel!
    
    @IBOutlet weak var tableVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_StatusOnOff: UILabel!
    @IBOutlet weak var switchOnOff: UISwitch!
  
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var status_Vw: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var findDriver: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btn_NotificationOt: UIButton!
    
    var arrayOfNewRequest: [ResPendingRequest] = []
    
    var animator: UIViewPropertyAnimator!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOt.register(UINib(nibName: "NewRequestCell", bundle: nil), forCellReuseIdentifier: "NewRequestCell")
        self.status_Vw.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickAction))
        self.view.addGestureRecognizer(tapGesture)
        
        Utility.showCurrentLocation(self.mapView, self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.profile()
        self.fetchNewRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchActivelyRunningRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
  
    func animateLeftView() {
        // Calculate a fixed target frame for leftView
        var targetFrame = leftView.frame
        targetFrame.origin.x = rightView.frame.maxX // Set to align with rightView's end point

        // Animate leftView to the target position
        UIView.animate(withDuration: 4.0, delay: 0, options: [.curveEaseInOut, .repeat]) {
            self.leftView.frame = targetFrame
        }
    }

    func animateRightView() {
        // Calculate a fixed target frame for rightView
        var targetFrame = rightView.frame
        targetFrame.origin.x = -rightView.frame.width // Move off-screen to the left

        // Animate rightView to the target position
        UIView.animate(withDuration: 4.0, delay: 0, options: [.curveEaseInOut, .repeat]) {
            self.rightView.frame = targetFrame
        }
    }
  
    @objc func clickAction()
    {
        self.status_Vw.isHidden = true
    }
    
    @IBAction func btn_SetCurrentLocation(_ sender: UIButton) {
        Utility.showCurrentLocation(self.mapView, self)
    }
    
    @IBAction func btn_Status(_ sender: UIButton) {
        status_Vw.isHidden = false
    }
    
    @IBAction func btn_DriverStatus(_ sender: UISwitch) {
        if sender.isOn {
            print("Should online")
            self.updateDriverStatus("ONLINE")
            Switcher.updateRootVC()
        } else {
            print("Should offline")
            self.updateDriverStatus("OFFLINE")
            Switcher.updateRootVC()
        }
    }
    
    @IBAction func btnList(_ sender: UIButton) {
        toggleLeft()
    }
    
    @IBAction func btnSchedule(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Notification(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vC.isFrom = "Home"
        self.navigationController?.pushViewController(vC, animated: true)
    }
}

extension HomeVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfNewRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewRequestCell", for: indexPath) as! NewRequestCell
        let obj = self.arrayOfNewRequest[indexPath.row]
        
        if obj.book_for_others == "Yes" {
            cell.lblName.text! = "\(obj.guest_name ?? "") (Guest)"
            cell.profile_Img.image = R.image.profile_ic()
        } else {
            cell.lblName.text! = "\(obj.user_details?.first_name ?? "")"
            if Router.BASE_IMAGE_URL != obj.user_details?.image {
                Utility.setImageWithSDWebImage(obj.user_details?.image ?? "", cell.profile_Img)
            } else {
                cell.profile_Img.image = R.image.placeholder()
            }
        }
        
        cell.lblName.text = "\(obj.user_details?.first_name ?? "")"
        cell.lblTotalAmount.text = "\(k.currency)\(obj.driver_amount ?? "")"
        
        cell.lblRate.text = "\(obj.user_details?.rating ?? "") (\(obj.user_details?.rating_count ?? ""))"
        
        cell.lblPickupAddress.text = obj.pick_address ?? ""
        cell.lblDropAdderss.text = obj.drop_address ?? ""
        cell.lbl_HowMuchMinutes.text = "\(obj.ride_time ?? "") minutes trip"
        cell.lblDistance.text = "\(obj.time_away ?? "") mins away"
        
        cell.cloAccept = {
            self.requestAccept(obj.id ?? "", obj.booking_type ?? "")
        }
        
        cell.cloDecline = {() in
            self.cancelRequest(obj.id ?? "")
        }
        
        if let obj_UserStop = obj.user_request_stop {
            if obj_UserStop.count > 0 {
                cell.addStop_TableVw.isHidden = false
                cell.arrayOfUserStop = obj_UserStop
                cell.addStop_TableVw.reloadData()
            } else {
                cell.addStop_TableVw.isHidden = true
            }
        }
        
        cell.progressVw.progress = 0.0
        let minutes = (obj.admin_set_request_time ?? 0) / 60
        print(minutes)
        cell.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            let change: Float = 0.01
            cell.progressVw.progress = cell.progressVw.progress + (change)
            if Int(cell.progressVw.progress) >= minutes {
                cell.timer?.invalidate()
                self.tableViewOt.isHidden = true
            }
        })
        
        updateMapAnnotationsAndRoute(obj)
        
        return cell
    }
    
    private func updateMapAnnotationsAndRoute(_ obj: ResPendingRequest) {
        let pickupCoordinate = CLLocationCoordinate2D (
            latitude: Double(obj.pickup_lat ?? "") ?? 0.0,
            longitude: Double(obj.pickup_lon ?? "") ?? 0.0
        )
        
        let dropoffCoordinate = CLLocationCoordinate2D(
            latitude: Double(obj.dropoff_lat ?? "") ?? 0.0,
            longitude: Double(obj.dropoff_lon ?? "") ?? 0.0
        )
        
        var annotations = createPickupAndDropoffAnnotations(pickupCoordinate, dropoffCoordinate)
        let stopCoordinates = createStopCoordinates(obj)
        
        annotations.append(contentsOf: createStopAnnotations(stopCoordinates))
        
        self.mapView.addAnnotations(annotations)
        calculateRouteForDetailsRide(from: pickupCoordinate, to: dropoffCoordinate, waypoints: stopCoordinates, mapView: self.mapView)
    }
    
    private func createPickupAndDropoffAnnotations(_ pickupCoordinate: CLLocationCoordinate2D, _ dropoffCoordinate: CLLocationCoordinate2D) -> [CustomPointAnnotation] {
        let pickupAnnotation = CustomPointAnnotation()
        pickupAnnotation.coordinate = pickupCoordinate
        pickupAnnotation.imageName = "car_marker"
        
        let dropoffAnnotation = CustomPointAnnotation()
        dropoffAnnotation.coordinate = dropoffCoordinate
        dropoffAnnotation.imageName = "drop_map_ic"
        
        return [pickupAnnotation, dropoffAnnotation]
    }
    
    private func createStopCoordinates(_ obj: ResPendingRequest) -> [CLLocationCoordinate2D] {
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

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = self.arrayOfNewRequest[indexPath.row].user_request_stop ?? []
        if obj.count > 0 {
            return 350
        } else {
            return 300
        }
    }
}

// Driver Status Related
extension HomeVC {
    
    func profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.lblOverAllEarning.text! = "\(k.currency)\(obj.Driver_today_earning ?? "")\nToday Earning\n\(obj.request_count ?? "") trip completed today"
            if obj.noti_count == "0" {
                self.btn_NotificationOt.setImage(R.image.carbon_notification(), for: .normal)
            } else {
                self.btn_NotificationOt.setImage(R.image.carbon_notificationFiiled(), for: .normal)
            }
            if obj.available_status == "ONLINE" {
                self.lbl_StatusOnOff.text  = "Go Offline"
                self.switchOnOff.isOn = true
                self.textDriverStatus.text = "Finding rides"
                self.animatedView.isHidden = false
                self.animateLeftView()
                self.animateRightView()
            } else {
                self.lbl_StatusOnOff.text  = "Go Online"
                self.switchOnOff.isOn = false
                self.animatedView.isHidden = true
                self.textDriverStatus.text = "You are currently offline"
            }
        }
    }
    
    func updateDriverStatus(_ driverStatus: String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["available_status"]       = driverStatus as AnyObject
        
        Api.shared.updateStatus(self, dict) { responseData in
            Switcher.updateRootVC()
        }
    }
}

// New And Active Requests
extension HomeVC {
    
    func fetchNewRequest()
    {
        Api.shared.getPendingDriverReq(self) { [self] responseData in
            if responseData.count > 0 {
                self.tableViewOt.isHidden = false
                self.arrayOfNewRequest = responseData
                if responseData[0].user_request_stop != nil {
                    self.tableVwHeight.constant = CGFloat(self.arrayOfNewRequest.count * 350)
                } else {
                    self.tableVwHeight.constant = CGFloat(self.arrayOfNewRequest.count * 300)
                }
                self.findDriver.isHidden = true
            } else {
                self.arrayOfNewRequest = []
                self.tableViewOt.isHidden = true
                self.findDriver.isHidden = false
            }
            self.tableViewOt.reloadData()
        }
    }
    
    func fetchActivelyRunningRequest()
    {
        Api.shared.getActiveDriverReq(self) { responseData in
            let obj = responseData
            if obj.status != "Pending" {
                let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ArrivedVC") as! ArrivedVC
                vc.requestId = obj.id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// Driver's Choice Requests
extension HomeVC {
    
    func requestAccept(_ request_iD: String,_ booking_Type: String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["request_id"]             = request_iD as AnyObject
        dict["status"]                 = "Accept" as AnyObject
        
        Api.shared.updateDriverStatus(self, dict) { responseData in
            if booking_Type == "Later" {
                Switcher.updateRootVC()
            } else {
                let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ArrivedVC") as! ArrivedVC
                vc.requestId = request_iD
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func cancelRequest(_ cancelRequest_iD: String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["request_id"]             = cancelRequest_iD as AnyObject
        
        Api.shared.cancelRequest(self, dict) { responseData in
            self.fetchNewRequest()
        }
    }
}
