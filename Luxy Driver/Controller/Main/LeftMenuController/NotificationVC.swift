//
//  NotificationVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tableViewot: UITableView!
    @IBOutlet weak var lblHIdden: UILabel!
    
    var arrNotification: [ResNotification] = []
    
    var isFrom:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewot.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Notification", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.notification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        if isFrom != "Home" {
            self.toggleLeft()
        } else {
            Switcher.updateRootVC()
        }
    }
    
    func notification()
    {
        Api.shared.getNotification(self, self.paramDetail()) { responseData in
            if responseData.count > 0 {
                self.arrNotification = responseData
                self.lblHIdden.isHidden = true
            }else{
                self.arrNotification = []
                self.lblHIdden.isHidden = false
            }
            self.tableViewot.reloadData()
        }
    }
    
    func paramDetail() -> [String : AnyObject]
    {
        var dict: [String : AnyObject] = [:]
        dict["user_id"]                = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["type"]                   = "DRIVER" as AnyObject
        return dict
    }
}

extension NotificationVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let obj = self.arrNotification[indexPath.row]
        cell.lblTitle.text! = obj.title ?? ""
        cell.lblDescription.text! = obj.message ?? ""
        cell.lblDateTime.text! = obj.date_time ?? ""
        return cell
    }
}
