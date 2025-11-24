//
//  RatingVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 07/08/23.
//

import UIKit
import Cosmos

class RatingVC: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTrip: UILabel!
    @IBOutlet weak var vwCosmos: CosmosView!
    @IBOutlet weak var txtFeedback: UITextView!
    
    var user_Id = ""
    var request_Id = ""
    var driverId = ""
    
    var isFrom:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFeedback.addHint("Enter Comment")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Rating", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        if isFrom == "RideFinish" {
            Switcher.updateRootVC()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSubmitReview(_ sender: UIButton) {
        if self.txtFeedback.hasText {
            self.rate()
        } else {
            self.alert(alertmessage: "Please Enter the Feedback!")
        }
    }
}

extension RatingVC {
    
    func profile()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"]                = self.user_Id as AnyObject
        
        print(paramDict)
        
        Api.shared.getUserProfile(self, paramDict) { responseData in
            let obj = responseData
            self.lblUserName.text! = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            self.lblRating.text! = "\(obj.rating ?? "")(\(obj.noti_count ?? ""))"
            self.lblTrip.text! = "How was your trip with \(obj.first_name ?? "") \(obj.last_name ?? "")?"
        }
    }
    
    func rate()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["form_id"]                = k.userDefault.value(forKey: k.session.userId) as AnyObject
        paramDict["to_id"]                  = self.user_Id as AnyObject
        paramDict["request_id"]             = self.request_Id as AnyObject
        paramDict["rating"]                 = self.vwCosmos.rating as AnyObject
        paramDict["feedback"]               = self.txtFeedback.text as AnyObject
        
        print(paramDict)
        
        Api.shared.giveRating(self, paramDict) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Rated Successfully!", delegate: nil, parentViewController: self) { boool in
                Switcher.updateRootVC()
            }
        }
    }
}
