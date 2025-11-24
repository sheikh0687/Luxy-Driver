//
//  WithdrawAmountVC.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit

class WithdrawAmountVC: UIViewController {

    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var txtAccountNum: UITextField!
    @IBOutlet weak var txtAccountHoldName: UITextField!
    @IBOutlet weak var txtIfscCode: UITextField!
    @IBOutlet weak var txtBankBranch: UITextField!
    
    var amount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTotalAmount.text = amount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Withdraw Amount", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        if isvalidInputs() {
            addRequest()
        }
    }
    
    func isvalidInputs() -> Bool {
        var isValid: Bool = true
        var errorMessage: String? = ""
        
        if (self.txtAccountNum.text!.isEmpty) {
            errorMessage = "Please enter account number"
            isValid = false
        } else if (self.txtAccountHoldName.text!.isEmpty) {
            errorMessage = "Please enter account holder name"
            isValid = false
        } else if (self.txtIfscCode.text!.isEmpty) {
            errorMessage = "Please enter IFSC code"
            isValid = false
        } else if (self.txtBankBranch.text!.isEmpty) {
            errorMessage = "Please enter branch name"
            isValid = false
        }
        
        if (isValid == false) {
            self.alert(alertmessage: errorMessage ?? "")
        }
        
        return isValid
    }
}

extension WithdrawAmountVC {
    
    func addRequest() {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"]                = k.userDefault.value(forKey: k.session.userId) as AnyObject
        paramDict["amount"]                 = self.lblTotalAmount.text as AnyObject
        paramDict["account_number"]         = self.txtAccountNum.text as AnyObject
        paramDict["account_holder_name"]    = self.txtAccountHoldName.text as AnyObject
        paramDict["ifsc_code"]              = self.txtIfscCode.text as AnyObject
        paramDict["description"]            = k.emptyString as AnyObject
        paramDict["branch"]                 = self.txtBankBranch.text as AnyObject

        print(paramDict)
        
        Api.shared.addRequest(self, paramDict) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Request added successfully", delegate: nil, parentViewController: self) { boool in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
