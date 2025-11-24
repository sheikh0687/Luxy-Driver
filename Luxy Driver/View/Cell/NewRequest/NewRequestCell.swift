//
//  NewRequestCell.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit

class NewRequestCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lbl_HowMuchMinutes: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropAdderss: UILabel!
//    @IBOutlet weak var lbl_TotalTime: UILabel!
//    @IBOutlet weak var lbl_RequestStatus: UILabel!
    @IBOutlet weak var progressVw: UIProgressView!
    @IBOutlet weak var addStop_TableVw: UITableView!
    
    @IBOutlet weak var profile_Img: UIImageView!
    
    var cloAccept:(() -> Void)?
    var cloDecline: (() -> Void)?
    
    var timer: Timer?
    var total_Seconds:Int!
    
    var arrayOfUserStop: [User_request_stop] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addStop_TableVw.register(UINib(nibName: "UserStopCell", bundle: nil), forCellReuseIdentifier: "UserStopCell")
        self.addStop_TableVw.delegate = self
        self.addStop_TableVw.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAccept(_ sender: UIButton) {
        self.cloAccept?()
    }
    
    @IBAction func btnDecline(_ sender: UIButton) {
        self.cloDecline?()
    }
    
//    func start_Timer()
//    {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountDown), userInfo: nil, repeats: true)
//    }
    
//    @objc func CountDown()
//    {
//        var minutes: Int
//        var second: Int
//        
//        total_Seconds = total_Seconds - 1
//        minutes = total_Seconds / 60
//        second = total_Seconds % 60
//        self.lbl_TotalTime.text = "Remaining time to action \(String(format: "%02d min: %02d sec",  minutes, second))"
//    }
    
}

extension NewRequestCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfUserStop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserStopCell", for: indexPath) as! UserStopCell
        let obj = self.arrayOfUserStop[indexPath.row]
        cell.lbl_StopAddress.text = obj.stop_address ?? ""
        cell.button_Vw.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
