//
//  BankDetailVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 18/12/23.
//

import UIKit

class BankDetailVC: UIViewController {

    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNum: UITextField!
    @IBOutlet weak var txtBankAddress: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtVenmoAccount: UITextField!
    @IBOutlet weak var txtZelleTransfer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Bank Detail", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.bank_Profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bank_Profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.txtAccountHolderName.text = obj.account_holder_name ?? ""
            self.txtBankName.text = obj.bank_name ?? ""
            self.txtAccountNum.text = obj.account_number ?? ""
            self.txtBankAddress.text = obj.bank_address ?? ""
            self.txtCode.text = obj.swify_bic_code ?? ""
            self.txtVenmoAccount.text = obj.venmo_account ?? ""
            self.txtZelleTransfer.text = obj.zelle_transfer ?? ""
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        if self.txtAccountHolderName.hasText && self.txtBankName.hasText && self.txtAccountNum.hasText && self.txtBankAddress.hasText && self.txtCode.hasText && self.txtVenmoAccount.hasText && txtZelleTransfer.hasText {
            self.update_Bank_Details()
        } else {
            self.alert(alertmessage: "Please enter the required details!")
        }
    }
    
    func update_Bank_Details()
    {
        Api.shared.update_Driver_BankDt(self, param_Update_BankDt()) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Bank details updated successfully", delegate: nil, parentViewController: self) { bool in
                self.dismiss(animated: true)
            }
        }
    }
    
    func param_Update_BankDt() -> [String : AnyObject]
    {
        var dict: [String : AnyObject] = [:]
        dict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        dict["account_holder_name"]    = self.txtAccountHolderName.text as AnyObject
        dict["bank_name"]              = self.txtBankName.text as AnyObject
        dict["account_number"]         = self.txtAccountNum.text as AnyObject
        dict["bank_address"]           = self.txtBankAddress.text as AnyObject
        dict["swify_bic_code"]         = self.txtCode.text as AnyObject
        dict["venmo_account"]          = self.txtVenmoAccount.text as AnyObject
        dict["zelle_transfer"]         = self.txtZelleTransfer.text as AnyObject
        return dict
    }
}
