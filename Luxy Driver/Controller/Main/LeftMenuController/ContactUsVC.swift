//
//  ContactUsVC.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit

class ContactUsVC: UIViewController {
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMessage.addHint("Message")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Contact Us", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        toggleLeft()
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if self.txtMessage.hasText && self.txtEmail.hasText {
            self.complaint()
        }else{
            self.alert(alertmessage: "Please Enter the required details")
        }
    }
    
    func complaint()
    {
        Api.shared.makeComplaint(self, self.paramDetails()) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "We will contact to you soon", delegate: nil, parentViewController: self) { boool in
                Switcher.updateRootVC()
            }
        }
    }
    
    func paramDetails() -> [String : AnyObject]
    {
        var dict: [String : AnyObject] = [:]
        dict["user_id"]                = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["email"]                  = self.txtEmail.text as AnyObject
        dict["message"]                = self.txtMessage.text as AnyObject
        return dict
    }
}
