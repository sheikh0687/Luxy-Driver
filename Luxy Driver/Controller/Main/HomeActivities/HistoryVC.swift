//
//  HistoryVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tableViewOt: UITableView!
    @IBOutlet weak var lblHidden: UILabel!
    
    var arrHistory: [ResHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOt.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "History", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.history()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func history()
    {
        Api.shared.getHistory(self) { responseData in
            if responseData.count > 0 {
                self.arrHistory = responseData
                self.lblHidden.isHidden = true
            }else{
                self.arrHistory = []
                self.lblHidden.isHidden = false
            }
            self.tableViewOt.reloadData()
        }
    }
}

extension HistoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let obj = self.arrHistory[indexPath.row]
        
        cell.lblPickupAddress.text = obj.pick_address ?? ""
        cell.lblDropAddress.text! = obj.drop_address ?? ""
        cell.lblTotalAmount.text! = "\(k.currency)\(obj.total_amount ?? "")(\(obj.payment_type ?? ""))"
        cell.lblDateTime.text! = obj.date_time ?? ""
        
        if obj.status != "Cancel" {
            cell.lblCancelled.backgroundColor = hexStringToUIColor(hex: "#E8FBF1")
            cell.lblCancelled.textColor = hexStringToUIColor(hex: "#188413")
            cell.lblCancelled.text = "Completed"
        } else {
            cell.lblCancelled.backgroundColor = hexStringToUIColor(hex: "#FCECEF")
            cell.lblCancelled.textColor = .red
            cell.lblCancelled.text = "Cancelled"
        }

        if obj.rating_review_status == "Yes" {
            cell.btnRatingOt.isHidden = true
        } else {
            cell.btnRatingOt.isHidden = false
        }
        
        if obj.received_rating_review_status == "Yes" {
            cell.lblFeedback.text! = obj.feedback ?? ""
            cell.vwCosmos.rating = Double(obj.rating ?? "") ?? 0.0
            cell.vwRating.isHidden = false
        } else {
            cell.vwRating.isHidden = true
        }
        
        cell.cloRating = {() in
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            vc.user_Id = obj.user_id ?? ""
            vc.request_Id = obj.id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
}

extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrHistory[indexPath.row]
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "RideDetailVC") as! RideDetailVC
        vC.request_iD = obj.id ?? ""
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
}
