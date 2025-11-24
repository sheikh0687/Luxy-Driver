//
//  ChangePasswordVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Change Password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        toggleLeft()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if self.txtCurrentPassword.hasText && self.txtNewPassword.hasText && self.txtConfirmPassword.hasText {
            self.changePassword()
        }else{
            self.alert(alertmessage: "Please Enter the required details!")
        }
    }
    
    func paramDetails() -> [String : AnyObject]
    {
        var dict: [String : AnyObject] = [:]
        dict["user_id"]                = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["password"]               = self.txtNewPassword.text! as AnyObject
        dict["old_password"]           = self.txtCurrentPassword.text! as AnyObject
        return dict
    }
    
    func changePassword()
    {
        Api.shared.changePassword(self, self.paramDetails()) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "New Password has been sent to your email address!", delegate: nil, parentViewController: self) { boool in
                Switcher.updateRootVC()
            }
        }
    }
}
