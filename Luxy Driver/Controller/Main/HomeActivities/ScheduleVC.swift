//
//  ScheduleVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 18/12/23.
//

import UIKit

class ScheduleVC: UIViewController {
    
    @IBOutlet weak var btnPendingOt: UIButton!
    @IBOutlet weak var btnUpcomingOt: UIButton!
    @IBOutlet weak var btnInProgressOt: UIButton!
    @IBOutlet weak var scheduleTableVw: UITableView!
    
    var arr_Schedule: [ResSchedule] = []
    var statuSs = "Pending"
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPendingOt.backgroundColor = .black
        self.btnPendingOt.setTitleColor(.white, for: .normal)
        self.btnUpcomingOt.backgroundColor = .white
        self.btnUpcomingOt.setTitleColor(.black, for: .normal)
        self.btnInProgressOt.backgroundColor = .white
        self.btnInProgressOt.setTitleColor(.black, for: .normal)
        self.scheduleTableVw.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.backgroundColor = hexStringToUIColor(hex: "#FAFAFA")
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Scheduled Booking", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#000000", TintColor: "#000000", Menu: "")
        self.schedule_Slot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    override func leftClick() {
        Switcher.updateRootVC()
    }
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        self.schedule_Slot()
    }
    
    @IBAction func btnPending(_ sender: UIButton) {
        self.btnPendingOt.backgroundColor = .black
        self.btnPendingOt.setTitleColor(.white, for: .normal)
        self.btnUpcomingOt.backgroundColor = .white
        self.btnUpcomingOt.setTitleColor(.black, for: .normal)
        self.btnInProgressOt.backgroundColor = .white
        self.btnInProgressOt.setTitleColor(.black, for: .normal)
        self.statuSs = "Pending"
        self.schedule_Slot()
        timer?.invalidate()
        startTimer()
    }
    
    @IBAction func btnUpcoming(_ sender: UIButton) {
        self.btnUpcomingOt.backgroundColor = .black
        self.btnUpcomingOt.setTitleColor(.white, for: .normal)
        self.btnPendingOt.backgroundColor = .white
        self.btnPendingOt.setTitleColor(.black, for: .normal)
        self.btnInProgressOt.backgroundColor = .white
        self.btnInProgressOt.setTitleColor(.black, for: .normal)
        self.statuSs = "Upcoming"
        self.schedule_Slot()
        timer?.invalidate()
        startTimer()
    }
    
    @IBAction func btnInProgress(_ sender: UIButton) {
        self.btnInProgressOt.backgroundColor = .black
        self.btnInProgressOt.setTitleColor(.white, for: .normal)
        self.btnUpcomingOt.backgroundColor = .white
        self.btnUpcomingOt.setTitleColor(.black, for: .normal)
        self.btnPendingOt.backgroundColor = .white
        self.btnPendingOt.setTitleColor(.black, for: .normal)
        self.statuSs = "Progress"
        self.schedule_Slot()
        timer?.invalidate()
        startTimer()
    }
    
    func schedule_Slot()
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["status"]                 = statuSs as AnyObject
        dict["timezone"]               = localTimeZoneIdentifier as AnyObject
        
        print(dict)
        
        Api.shared.getSchedule(self, dict) { responseData in
            if responseData.status == "1" {
                if let res_Result = responseData.result {
                    if res_Result.count > 0 {
                        self.arr_Schedule = res_Result
                        self.scheduleTableVw.backgroundView = UIView()
                        self.scheduleTableVw.reloadData()
                    }
                }
            } else {
                self.arr_Schedule = []
                self.scheduleTableVw.backgroundView = UIView()
                Utility.noDataFound("No Data Available", tableViewOt: self.scheduleTableVw, parentViewController: self)
            }
            self.scheduleTableVw.reloadData()
        }
    }
}

extension ScheduleVC {
    
    func requestAccept(_ request_iD: String, status: String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["request_id"]             = request_iD as AnyObject
        dict["status"]                 = status as AnyObject
        
        print(dict)
        
        Api.shared.updateDriverStatus(self, dict) { responseData in
            if responseData.status == "Accept" {
                self.schedule_Slot()
            } else {
                let vC = R.storyboard.main().instantiateViewController(withIdentifier: "ArrivedVC") as! ArrivedVC
                self.navigationController?.pushViewController(vC, animated: true)
            }
        }
    }
    
    func confirm_Stop(_ statuss: String, user_iD:String, request_iD:String, requestStop_iD:String)
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        dict["user_id"]                = user_iD as AnyObject
        dict["request_id"]             = request_iD as AnyObject
        dict["request_stop_id"]        = requestStop_iD as AnyObject
        dict["status"]                 = statuss as AnyObject
        
        print(dict)
        
        Api.shared.add_Confirm_Stop(self, dict) { responseData in
            self.schedule_Slot()
        }
    }

}

extension ScheduleVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        let obj = self.arr_Schedule[indexPath.row]
        if statuSs == "Pending" {
            cell.lblPrice.text = "$\(obj.driver_amount ?? "")"
            cell.pickAddress.text = obj.pick_address ?? ""
            cell.dropAddres.text = obj.drop_address ?? ""
            cell.lblDate.text = obj.date ?? ""
            cell.lblTime.text = obj.time ?? ""
            cell.profileDetailVw.isHidden = true
            cell.viewProgress.isHidden = true
            cell.stop_TableVw.isHidden = true
            cell.lbl_MultipleStatus.isHidden = true
            cell.btn_CancelOt.isHidden = true
            cell.btn_DriverNowOt.isHidden = false
            
            if let obj_UserStop = obj.user_request_stop {
                if obj_UserStop.count > 0 {
                    cell.stop_TableVw.isHidden = false
                    cell.arrayUserStop = obj_UserStop
                    cell.stop_TableVw.reloadData()
                    cell.lbl_MultipleStatus.isHidden = false
                } else {
                    cell.stop_TableVw.isHidden = true
                    cell.lbl_MultipleStatus.isHidden = true
                }
            }
            
            if obj.book_for_others == "Yes" {
                cell.lbl_UserName.text! = "\(obj.guest_name ?? "") (Guest)"
                cell.profile_Img.image = R.image.profile_ic()
            } else {
                cell.lbl_UserName.text! = "\(obj.user_details?.first_name ?? "")"
                if Router.BASE_IMAGE_URL != obj.user_details?.image {
                    Utility.setImageWithSDWebImage(obj.user_details?.image ?? "", cell.profile_Img)
                } else {
                    cell.profile_Img.image = R.image.placeholder()
                }
            }
            
            cell.cloDriveNow = { [self] in
                requestAccept(obj.id ?? "", status: "Accept")
            }
            
        } else if statuSs == "Upcoming" {
            cell.profileDetailVw.isHidden = false
            cell.viewProgress.isHidden = false
            cell.lblPrice.isHidden = true
            cell.lbl_EstimateAmt.isHidden = true
            cell.lbl_EstimateArrivalTime.isHidden = true
            cell.btn_ChatOt.isHidden = true
            cell.btn_CancelOt.isHidden = false
            cell.btn_DriverNowOt.isHidden = false
            
            cell.pickAddress.text = obj.pick_address ?? ""
            cell.dropAddres.text = obj.drop_address ?? ""
            cell.lblDate.text = obj.date ?? ""
            cell.lblTime.text = obj.time ?? ""
            
            cell.lbl_UserName.text = obj.user_details?.first_name ?? ""
            cell.lbl_Rating.text = "\(obj.user_details?.rating ?? "") (\(obj.user_details?.rating_count ?? ""))"
            cell.lbl_DriverAmount.text = "$\(obj.driver_amount ?? "")"
            cell.lbl_DistanceInMinutes.text = "\(obj.time_away ?? "") minutes away"
            
            if let obj_UserStop = obj.user_request_stop {
                if obj_UserStop.count > 0 {
                    cell.stop_TableVw.isHidden = false
                    cell.arrayUserStop = obj_UserStop
                    cell.stop_TableVw.reloadData()
                    cell.lbl_MultipleStatus.isHidden = false
                } else {
                    cell.stop_TableVw.isHidden = true
                    cell.lbl_MultipleStatus.isHidden = true
                }
            }
            
            if obj.book_for_others == "Yes" {
                cell.lbl_UserName.text! = "\(obj.guest_name ?? "") (Guest)"
                cell.profile_Img.image = R.image.profile_ic()
            } else {
                cell.lbl_UserName.text! = "\(obj.user_details?.first_name ?? "")"
                if Router.BASE_IMAGE_URL != obj.user_details?.image {
                    Utility.setImageWithSDWebImage(obj.user_details?.image ?? "", cell.profile_Img)
                } else {
                    cell.profile_Img.image = R.image.profile_ic()
                }
            }
            
            if obj.request_remain_status == "Yes" {
                cell.btn_DriverNowOt.backgroundColor = .black
                cell.btn_DriverNowOt.isEnabled = true
            } else {
                if obj.request_time_passed == "Yes" {
                    cell.btn_DriverNowOt.backgroundColor = .black
                    cell.btn_DriverNowOt.isEnabled = true
                } else {
                    cell.btn_DriverNowOt.backgroundColor = .lightGray
                    cell.btn_DriverNowOt.isEnabled = false
                    print("Did Enter")
                }
            }
            
            if obj.request_remain_status == "Yes" {
                
                if let serverTotalSecond = obj.req_remain_long_time {
                    let serverTotalMinutes = obj.request_remain_time ?? 0.0
                    
                    let totalTimeInSeconds = serverTotalMinutes * 60
                    print(totalTimeInSeconds)
                    var elapsedTime = serverTotalSecond
                    print(elapsedTime)
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        
                        elapsedTime -= 1 // Decrement the elapsed time by 1 second.
                        let progress = min(Float(elapsedTime) / Float(totalTimeInSeconds), 1.0)
                        print(progress)
                        // Update circular progress view.
                        cell.circleProgressVw.setProgressWithAnimation(duration: 0.5, value: progress)
                        
                        // Update the timer label dynamically.
                        cell.lbl_SetTimer.text = self.formatTime(TimeInterval(elapsedTime))
                        
                        // Change the color of the circular progress if it exceeds free time.
                        if elapsedTime < 900 {
                            cell.circleProgressVw.setProgressColor = .red
                            cell.lbl_SetTimer.textColor = .red
                        }
                        
                        if elapsedTime <= 0 {
                            timer.invalidate()  // Stop the timer
                            cell.lbl_SetTimer.text = self.formatTime(0)
                            cell.circleProgressVw.setProgressColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                            cell.lbl_SetTimer.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)// Set the label to 00:00
                        }
                    }
                }
            }
            
            cell.cloDriveNow = { [self] in
                requestAccept(obj.id ?? "", status: "Drive Now")
            }
            
            cell.cloCancel = { [self] in
                let vC = R.storyboard.main().instantiateViewController(withIdentifier: "PresentCancelVC") as! PresentCancelVC
                vC.cloCancelReason = { [] in
                    let vC = R.storyboard.main().instantiateViewController(withIdentifier: "PresentCancelReasonVC") as! PresentCancelReasonVC
                    vC.modalTransitionStyle = .crossDissolve
                    vC.modalPresentationStyle = .overFullScreen
                    self.present(vC, animated: true)
                }
                vC.modalTransitionStyle = .crossDissolve
                vC.modalPresentationStyle = .overFullScreen
                self.present(vC, animated: true)
            }
            
        } else {
            cell.profileDetailVw.isHidden = false
            cell.viewProgress.isHidden = true
            cell.lblPrice.isHidden = true
            //            cell.lbl_DriverAmount.isHidden = true
            cell.btn_NotifyOt.isHidden = true
            cell.btn_DriverNowOt.isHidden = true
            cell.lbl_EstimateAmt.isHidden = true
            cell.lbl_EstimateArrivalTime.isHidden = false
            cell.btn_ChatOt.isHidden = false
            cell.btn_CancelOt.isHidden = false
            cell.btn_CancelOt.setTitle("Notify Arrived", for: .normal)
            
            cell.pickAddress.text = obj.pick_address ?? ""
            cell.dropAddres.text = obj.drop_address ?? ""
            cell.lblDate.text = obj.date ?? ""
            cell.lblTime.text = obj.time ?? ""
            cell.lbl_DriverAmount.text = "$\(obj.driver_amount ?? "")"
            //            cell.lbl_EstimateAmt.text = "Estimate :$\(obj.driver_amount ?? "")"
            cell.lbl_EstimateArrivalTime.text = "Estimate Arrival Time: \(obj.time ?? "") minutes"
            
            if let obj_UserStop = obj.user_request_stop {
                if obj_UserStop.count > 0 {
                    cell.stop_TableVw.isHidden = false
                    cell.arrayUserStop = obj_UserStop
                    cell.stop_TableVw.reloadData()
                    cell.lbl_MultipleStatus.isHidden = false
                } else {
                    cell.stop_TableVw.isHidden = true
                    cell.lbl_MultipleStatus.isHidden = true
                }
            }
            
            if obj.book_for_others == "Yes" {
                cell.lbl_UserName.text! = "\(obj.guest_name ?? "") (Guest)"
                cell.profile_Img.image = R.image.profile_ic()
            } else {
                cell.lbl_UserName.text! = "\(obj.user_details?.first_name ?? "")"
                if Router.BASE_IMAGE_URL != obj.user_details?.image {
                    Utility.setImageWithSDWebImage(obj.user_details?.image ?? "", cell.profile_Img)
                } else {
                    cell.profile_Img.image = R.image.placeholder()
                }
            }
            
            cell.cloCancel = { [self] in
                if obj.status == "Drive Now" {
                    requestAccept(obj.id ?? "", status: "Arrived")
                    cell.btn_CancelOt.setTitle("Notify Arrived", for: .normal)
                } else if obj.status == "Arrived" {
                    requestAccept(obj.id ?? "", status: "Start")
                    cell.btn_CancelOt.setTitle("Start Pickup", for: .normal)
                } else if obj.status == "Start" {
                    if let userRequestStop = obj.user_request_stop, !userRequestStop.isEmpty {
                        if obj.status == "Pending" || obj.status == "Waiting_Time_Start" {
                            cell.btn_CancelOt.setTitle("Confirm Stop", for: .normal)
                            self.confirm_Stop("Waiting_Time_Start", user_iD: obj.user_id ?? "", request_iD: obj.id ?? "", requestStop_iD: userRequestStop[0].id ?? "")
                            if obj.status == "Waiting_Time_Start" {
                                cell.btn_CancelOt.setTitle("Move Next", for: .normal)
                                self.confirm_Stop("Waiting_Time_End", user_iD: obj.user_id ?? "", request_iD: obj.id ?? "", requestStop_iD: userRequestStop[0].id ?? "")
                            } else {
                                
                            }
                        }
                    }
                }
            }
            
        }
        return cell
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension ScheduleVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arr_Schedule[indexPath.row]
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "RideDetailVC") as! RideDetailVC
        vC.request_iD = obj.id ?? ""
        self.navigationController?.pushViewController(vC, animated: true)
    }
}
