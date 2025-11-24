//
//  PresentCancelReasonVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/12/24.
//

import UIKit

class PresentCancelReasonVC: UIViewController {

    @IBOutlet weak var reason_TableVw: UITableView!
    @IBOutlet weak var reasonTableHeight: NSLayoutConstraint!
    
    var request_iD:String = ""
    var reasonDetail:String = ""
    
    var arrayOfReason: [Res_CancelReason] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reason_TableVw.register(UINib(nibName: "ReasonListCell", bundle: nil), forCellReuseIdentifier: "ReasonListCell")
        fetchCancelReason()
    }
    
    @IBAction func btn_Dismisss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_CancelRequest(_ sender: UIButton) {
        if reasonDetail != "" {
            updateDriverStatus()
        } else {
            self.alert(alertmessage: "Please select the reason")
        }
    }
}

extension PresentCancelReasonVC {
    
    func fetchCancelReason()
    {
        Api.shared.requestToCancelReason(self) { responseData in
            if responseData.count > 0 {
                self.arrayOfReason = responseData
                self.reasonTableHeight.constant = CGFloat(self.arrayOfReason.count * 45)
            } else {
                self.arrayOfReason = []
            }
            self.reason_TableVw.reloadData()
        }
    }
    
    func updateDriverStatus()
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["request_id"]             = self.request_iD as AnyObject
        dict["lat"]                    = kAppDelegate.CURRENT_LAT as AnyObject
        dict["lon"]                    = kAppDelegate.CURRENT_LON as AnyObject
        dict["status"]                 = "Reject" as AnyObject
        dict["reason_title"]           = k.emptyString as AnyObject
        dict["reason_detail"]          = self.reasonDetail as AnyObject
        
        print(dict)
        
        Api.shared.updateDriverStatus(self, dict) { responseData in
            Switcher.updateRootVC()
        }
    }
}

extension PresentCancelReasonVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfReason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonListCell", for: indexPath) as! ReasonListCell
        let obj = self.arrayOfReason[indexPath.row]
        cell.lbl_Reason.text = obj.reason ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReasonListCell
        let obj = self.arrayOfReason[indexPath.row]
        
        self.reasonDetail = obj.reason ?? ""
        
        cell.check_Img.image = R.image.circleCheck()
        let indexPaths = tableView.indexPathsForVisibleRows
        for indexPathOth in indexPaths! {
            if indexPathOth.row != indexPath.row && indexPathOth.section == indexPath.section {
                let cell1 = tableView.cellForRow(at: IndexPath(row: indexPathOth.row, section: indexPathOth.section)) as! ReasonListCell
                cell1.check_Img.image = R.image.circle()
            }
        }
    }
}
