//
//  ForgotPasswordVC.swift
//  City Spriiint
//
//  Created by Techimmense Software Solutions on 19/07/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Forgot Password", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        if self.txtEmail.hasText {
            self.forgotPassword()
        } else {
            self.alert(alertmessage: "Please Enter the Email!")
        }
    }
}

extension ForgotPasswordVC {
    func forgotPassword() {
        
        var paramDict: [String : AnyObject] = [:]
        paramDict["email"]                  = self.txtEmail.text! as AnyObject
        
        print(paramDict)
        
        Api.shared.forgotPassword(self, paramDict) { (response) in
            if response.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "New password has sent to your email!", delegate: nil, parentViewController: self) { (bool) in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                Utility.showAlertMessage(withTitle: k.appName, message: "Email does not exist!", delegate: nil, parentViewController: self)
            }
        }
    }
}
