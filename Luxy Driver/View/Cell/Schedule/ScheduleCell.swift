//
//  ScheduleCell.swift
//  Luxy
//
//  Created by Techimmense Software Solutions on 05/01/24.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var profile_Img: UIImageView!
    
    @IBOutlet weak var btn_NotifyOt: UIButton!
    @IBOutlet weak var btn_ChatOt: UIButton!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var pickAddress: UILabel!
    @IBOutlet weak var dropAddres: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var lbl_DriverAmount: UILabel!
    @IBOutlet weak var lbl_MultipleStatus: UILabel!
    
    @IBOutlet weak var lbl_EstimateAmt: UILabel!
    @IBOutlet weak var lbl_EstimateArrivalTime: UILabel!
    
    @IBOutlet weak var lbl_DistanceInMinutes: UILabel!
    @IBOutlet weak var circleProgressVw: CircularProgressView!
    @IBOutlet weak var lbl_SetTimer: UILabel!
    
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var actionStackVw: UIStackView!
    @IBOutlet weak var profileDetailVw: UIView!
    
    @IBOutlet weak var stop_TableVw: UITableView!
    
    @IBOutlet weak var btn_DriverNowOt: UIButton!
    @IBOutlet weak var btn_CancelOt: UIButton!
   
    var cloDriveNow:(() -> Void)?
    var cloCancel:(() -> Void)?
    var cloNotify:(() -> Void)?
    var cloChat:(() -> Void)?
    
    var arrayUserStop: [User_request_stop] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stop_TableVw.register(UINib(nibName: "UserStopCell", bundle: nil), forCellReuseIdentifier: "UserStopCell")
        self.stop_TableVw.delegate = self
        self.stop_TableVw.dataSource = self
        
        circleProgressVw.setTrackColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        circleProgressVw.setProgressColor = .lightGray
        lbl_SetTimer.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCancelRide(_ sender: UIButton) {
        self.cloCancel?()
    }
    
    @IBAction func btn_DriverNow(_ sender: UIButton) {
        self.cloDriveNow?()
    }
    
    @IBAction func btn_Chat(_ sender: UIButton) {
        self.cloChat?()
    }
    
    @IBAction func btn_Notify(_ sender: UIButton) {
        self.cloNotify?()
    }
}

extension ScheduleCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUserStop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserStopCell", for: indexPath) as! UserStopCell
        let obj = self.arrayUserStop[indexPath.row]
        cell.lbl_StopAddress.text = obj.stop_address ?? ""
        cell.button_Vw.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
