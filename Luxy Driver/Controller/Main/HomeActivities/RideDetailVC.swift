//
//  RideDetailVC.swift
//  Luxy
//
//  Created by Techimmense Software Solutions on 29/11/24.
//

import UIKit
import MapKit

class RideDetailVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lbl_DriverName: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    
    @IBOutlet weak var lbl_PickupAddress: UILabel!
    @IBOutlet weak var lbl_DropAddress: UILabel!
    
    @IBOutlet weak var lbl_DriverVehicleNum: UILabel!
    @IBOutlet weak var lbl_DriverFare: UILabel!
    
    @IBOutlet weak var stop_TableVw: UITableView!
    @IBOutlet weak var stop_TableHeight: NSLayoutConstraint!
    @IBOutlet weak var stopAddressVw: UIStackView!
    
    @IBOutlet weak var lbl_FlightName:UILabel!
    @IBOutlet weak var lbl_FlightNumber:UILabel!
    @IBOutlet weak var lbl_BoosterSeat:UILabel!
    @IBOutlet weak var lbl_RearFacingSeat:UILabel!
    @IBOutlet weak var lbl_ForwarFacingSeat:UILabel!
    
    @IBOutlet weak var airlineBookingVw: UIStackView!
    @IBOutlet weak var boosterSeatVw: UIStackView!
    @IBOutlet weak var rearFacingSeatVw: UIStackView!
    @IBOutlet weak var forwardFacingSeatVw: UIStackView!
    
    @IBOutlet weak var bookingForOthersVw: UIStackView!
    @IBOutlet weak var lbl_GuestName: UILabel!
    @IBOutlet weak var lbl_GuestContact: UILabel!
    
    @IBOutlet weak var lbl_PaymentMethod: UILabel!
    @IBOutlet weak var lbl_LongPickFee: UILabel!
    @IBOutlet weak var lbl_SubTotalAmount: UILabel!
    @IBOutlet weak var lbl_SubTotalText: UILabel!
    @IBOutlet weak var lbl_TipAmount: UILabel!
    
    @IBOutlet weak var lbl_OverllTotal: UILabel!
    @IBOutlet weak var tipAmountVw: UIStackView!
    @IBOutlet weak var btn_SayThankOt: UIButton!
    
    var request_iD:String = ""
    var user_iD:String = ""
    var arrayOfAddReq: [User_request_stop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stop_TableVw.register(UINib(nibName: "UserStopCell", bundle: nil), forCellReuseIdentifier: "UserStopCell")
        mapView.delegate = self
        fetchRequestDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .black
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Ride Details", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    @IBAction func btn_SayThankYou(_ sender: UIButton) {
        sayThanksForTip()
    }
}

extension RideDetailVC {
    
    func sayThanksForTip()
    {
        var paramDict: [String: AnyObject] = [:]
        paramDict["driver_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["user_id"] = user_iD as AnyObject
        paramDict["request_id"] = request_iD as AnyObject
        
        print(paramDict)
        
        Api.shared.fetchThanksMessage(self, paramDict) { responseData in
            if responseData.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "Thanks message added successfully", delegate: nil, parentViewController: self) { [self] bool in
                    self.fetchRequestDetails()
                }
            } else {
                print(responseData.message ?? "")
            }
        }
    }
        
    func fetchRequestDetails()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["request_id"] = request_iD as AnyObject
        paramDict["timezone"] = localTimeZoneIdentifier as AnyObject
        
        print(paramDict)
        
        Api.shared.fetchRequestDetails(self, paramDict) { [self] responseData in
            if responseData.status == "1" {
                let obj_Result = responseData.result
                
                self.user_iD = obj_Result?.user_id ?? ""
                self.lbl_DriverName.text = obj_Result?.driver_details?.first_name ?? ""
                self.lbl_Rating.text = obj_Result?.driver_details?.rating ?? ""
                self.lbl_PickupAddress.text = obj_Result?.pick_address ?? ""
                self.lbl_DropAddress.text = obj_Result?.drop_address ?? ""
                self.lbl_DriverVehicleNum.text = "\(obj_Result?.vehicle_name ?? "") (\(obj_Result?.driver_details?.registration_no ?? ""))"
                self.lbl_DriverFare.text = "$\(obj_Result?.total_amount ?? "")"
                
                self.lbl_PaymentMethod.text = "Online"
                self.lbl_LongPickFee.text = "$ \(obj_Result?.long_time_amount ?? "")"
                self.lbl_SubTotalText.text = "Sub Total (\(obj_Result?.distance ?? "") miles)"
                self.lbl_SubTotalAmount.text = "$ \(obj_Result?.driver_sub_amount ?? "")"
                self.lbl_OverllTotal.text = "$ \(obj_Result?.driver_amount ?? "")"
                
                if obj_Result?.tip_amount != "" {
                    self.lbl_TipAmount.text = "$ \(obj_Result?.tip_amount ?? "")"
                    self.tipAmountVw.isHidden = false
                } else {
                    self.tipAmountVw.isHidden = true
                }
                
                if obj_Result?.tip_thankyou_msg == "Yes" {
                    self.btn_SayThankOt.isHidden = true
                } else {
                    self.btn_SayThankOt.isHidden = false
                }
                
                if obj_Result?.airline_booking == "No" {
                    self.airlineBookingVw.isHidden = true
                } else {
                    self.airlineBookingVw.isHidden = false
                    self.lbl_FlightName.text = obj_Result?.airline_name ?? ""
                    self.lbl_FlightNumber.text = obj_Result?.flight_number ?? ""
                    
                    if obj_Result?.booster_seat != "" {
                        self.lbl_BoosterSeat.text = obj_Result?.booster_seat ?? ""
                        self.boosterSeatVw.isHidden = false
                    } else {
                        self.boosterSeatVw.isHidden = true
                    }
                    
                    if obj_Result?.rearface_seat != "" {
                        self.lbl_RearFacingSeat.text = obj_Result?.rearface_seat ?? ""
                        self.rearFacingSeatVw.isHidden = false
                    } else {
                        self.rearFacingSeatVw.isHidden = true
                    }
                    
                    if obj_Result?.forwardface_seat != "" {
                        self.lbl_ForwarFacingSeat.text = obj_Result?.forwardface_seat ?? ""
                        self.forwardFacingSeatVw.isHidden = false
                    } else {
                        self.forwardFacingSeatVw.isHidden = true
                    }
                }
                
                if obj_Result?.book_for_others == "No" {
                    self.bookingForOthersVw.isHidden = true
                } else {
                    self.bookingForOthersVw.isHidden = false
                    self.lbl_GuestName.text = obj_Result?.guest_name ?? ""
                    self.lbl_GuestContact.text = obj_Result?.guest_mobile ?? ""
                }
                
                if let res_UserStopReq = obj_Result?.user_request_stop {
                    if res_UserStopReq.count > 0 {
                        self.arrayOfAddReq = res_UserStopReq
                        self.stop_TableHeight.constant = CGFloat(self.arrayOfAddReq.count * 50)
                        self.stopAddressVw.isHidden = false
                    } else {
                        self.arrayOfAddReq = []
                        self.stopAddressVw.isHidden = true
                    }
                    stop_TableVw.reloadData()
                } else {
                    self.stopAddressVw.isHidden = true
                }
                
                self.updateMapAnnotationsAndRoute(obj_Result!)
                
            } else {
                print(responseData.message ?? "")
            }
        }
    }
    
    private func updateMapAnnotationsAndRoute(_ obj: Res_RequestDetails) {
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
    
    private func createStopCoordinates(_ obj: Res_RequestDetails) -> [CLLocationCoordinate2D] {
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

extension RideDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayOfAddReq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserStopCell", for: indexPath) as! UserStopCell
        let obj = self.arrayOfAddReq[indexPath.row]
        cell.lbl_StopAddress.text = obj.stop_address ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
