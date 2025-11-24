//
//  MyAccountVC.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit
import Cosmos

class MyAccountVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "My Account", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        toggleLeft()
    }
    
    func profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.lblName.text! = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            self.lblEmail.text! = obj.email ?? ""
            self.lblMobile.text! = obj.mobile ?? ""
            self.cosmosView.rating = Double(obj.rating ?? "") ?? 0.0
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.img)
            } else {
                self.img.image = R.image.profile_ic()
            }
        }
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHistory(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_VehiclePreference(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "VehiclePreferenceVC") as! VehiclePreferenceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnUpdateBankDt(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "BankDetailVC") as! BankDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddInfo(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "AddInfoVC") as! AddInfoVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWallet(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDeleteAccount(_ sender: UIButton)
    {
        Utility.showAlertYesNoAction(withTitle: k.appName, message: "Are you sure to delete your account", delegate: nil, parentViewController: self) { boool in
            if boool {
                self.deleteAccount()
            }
        }
    }
    
    func deleteAccount()
    {
        Api.shared.deleteAccount(self) { responseData in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            Switcher.updateRootVC()
        }
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        logout = false
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        Switcher.updateRootVC()
    }
}


