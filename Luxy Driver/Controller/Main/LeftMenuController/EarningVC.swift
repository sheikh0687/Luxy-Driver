//
//  EarningVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 15/12/23.
//

import UIKit

class EarningVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbl_OverallEarning: UILabel!
    @IBOutlet weak var lbl_TodayEarning: UILabel!
    
    var arr_AllEarnings: [Res_DriverEarnings] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVw.register(UINib(nibName: "EarningCell", bundle: nil), forCellReuseIdentifier: "EarningCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Earning", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        GetEarnings()
    }
    
    override func leftClick() {
        toggleLeft()
    }
}

extension EarningVC {
    
    func GetEarnings()
    {
        Api.shared.get_DriverEarnings(self) { responseData in
            let obj = responseData
            self.lbl_OverallEarning.text = "$\(obj.driver_total_earning ?? "")"
            self.lbl_TodayEarning.text = "$\(obj.driver_today_earning ?? "")"
            
            if let obj_Result = obj.result {
                if obj_Result.count > 0 {
                    self.arr_AllEarnings = obj_Result
                } else {
                    self.arr_AllEarnings = []
                }
                self.tblVw.reloadData()
            }
        }
    }
    
}

extension EarningVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_AllEarnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath) as! EarningCell
        
        let obj = self.arr_AllEarnings[indexPath.row]
        
        cell.lbl_PickAddress.text = obj.pick_address ?? ""
        cell.lbl_DropAddress.text = obj.drop_address ?? ""
        cell.lbl_Amount.text = "$\(obj.total_amount ?? "")"
        cell.lbl_Date.text = obj.date_time ?? ""
        
        return cell
    }
}
