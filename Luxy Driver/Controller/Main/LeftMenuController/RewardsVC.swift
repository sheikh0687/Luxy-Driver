//
//  RewardsVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 31/05/24.
//

import UIKit

class RewardsVC: UIViewController {

    @IBOutlet weak var lbl_Points: UILabel!
    @IBOutlet weak var lbl_BetweenDates: UILabel!
    @IBOutlet weak var level_Imgs: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Rewards", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        GetUserLevels()
    }
    
    override func leftClick() {
        toggleLeft()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension RewardsVC {
    
    func GetUserLevels()
    {
        Api.shared.get_UserLevel(self) { responseData in
            let obj = responseData
            
            self.lbl_Points.text = obj.total_points ?? ""
            self.lbl_BetweenDates.text = "Between: \(obj.start_date ?? "") - \(obj.end_date ?? "")"
            
            switch obj.user_level {
            case "Silver":
                self.level_Imgs.image = UIImage(named: "Silver")
            case "Platinum":
                self.level_Imgs.image = UIImage(named: "Platinum")
            default:
                self.level_Imgs.image = UIImage(named: "Gold")
            }
        }
    }
}
