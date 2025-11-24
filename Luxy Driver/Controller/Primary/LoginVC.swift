//
//  LoginVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit
import CountryPickerView

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCountryPicker: UITextField!
    
    let cpvInternal = CountryPickerView()
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String?
    var phoneNumber: String = ""
    var countryCode = ""
    var countryCodeWithoutPlus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCountryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignup(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if self.txtMobile.hasText && self.txtPassword.hasText {
            self.login()
        } else {
            self.alert(alertmessage: "Please Enter the Required Details!")
        }
    }
}

extension LoginVC {
    
    func configureCountryView() {
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 14))
        cp.flagImageView.isHidden = true
        txtCountryPicker.rightView = cp
        txtCountryPicker.rightViewMode = .always
        self.cpvTextField = cp
        let countryCode = "US"
        self.cpvTextField.setCountryByCode(countryCode)
        cp.delegate = self
        [cp].forEach {
            $0?.dataSource = self
        }
        self.phoneKey = cp.selectedCountry.phoneCode
        cp.countryDetailsLabel.font = UIFont.systemFont(ofSize: 12)
        cp.font = UIFont.systemFont(ofSize: 12)
    }
    
    func login() {
        var paramDict:[String: AnyObject]         = [:]
        paramDict["mobile"]                       = self.txtMobile.text as AnyObject
        paramDict["mobile_witth_country_code"]    = self.countryCode as AnyObject
        paramDict["password"]                     = self.txtPassword.text as AnyObject
        paramDict["register_id"]                  = k.emptyString as AnyObject
        paramDict["ios_register_id"]              = k.iosRegisterId as AnyObject
        paramDict["lat"]                          = k.emptyString as AnyObject
        paramDict["lon"]                          = k.emptyString as AnyObject
        paramDict["type"]                         = "DRIVER" as AnyObject
        
        print(paramDict)
        
        Api.shared.login(self, paramDict) { responseData in
            k.userDefault.set(true, forKey: k.session.status)
            k.userDefault.set(responseData.id ?? "", forKey: k.session.userId)
            k.userDefault.set("\(responseData.first_name ?? "") \(responseData.last_name ?? "")", forKey: k.session.userName)
            k.userDefault.set(responseData.email ?? "", forKey: k.session.userEmail)
            Switcher.updateRootVC()
        }
    }
}

extension LoginVC: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
        self.countryCode = country.phoneCode
        self.countryCodeWithoutPlus = countryCode.replacingOccurrences(of: "+", with: "")
    }
}

extension LoginVC: CountryPickerViewDataSource {
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        var countries = [Country]()
        ["GB"].forEach { code in
            if let country = countryPickerView.getCountryByCode(code) {
                countries.append(country)
            }
        }
        return countries
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Preferred title"
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
