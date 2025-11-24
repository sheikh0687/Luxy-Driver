//
//  SignUpVC.swift
//  City Spriiint
//
//  Created by Techimmense Software Solutions on 19/07/23.
//

import UIKit
import CountryPickerView


class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtCountryPicker: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTermCondition: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btn_LuxyDriverOt: UIButton!
    @IBOutlet weak var btn_NormalDriverOt: UIButton!
    
    let cpvInternal = CountryPickerView()
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String?
    var phoneNumber: String = ""
    var countryCode = ""
    var countryCodeWithoutPlus = ""
    var strCheck:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCountryView()
        self.lblTermCondition.setColor(lblTermCondition)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        lblTermCondition.isUserInteractionEnabled = true
        lblTermCondition.addGestureRecognizer(tapGesture)
        self.btnCheck.setImage(UIImage(named: "Uncheck"), for: .normal)
    }
    
    @objc func labelClicked()
    {
//        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "TermConditionVC") as! TermConditionVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
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
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheck(_ sender: UIButton) {
        if self.btnCheck.image(for: .normal) == UIImage(named: "Uncheck") {
            self.btnCheck.setImage(UIImage(named: "Checked"), for: .normal)
            
        }else{
            self.btnCheck.setImage(UIImage(named: "Uncheck"), for: .normal)
        }
    }
    
    @IBAction func selectTypeOfAccount(_ sender: UIButton) {
        if sender.tag == 0 {
            btn_LuxyDriverOt.setImage(R.image.circleCheck(), for: .normal)
            btn_NormalDriverOt.setImage(R.image.circle(), for: .normal)
        } else {
            btn_LuxyDriverOt.setImage(R.image.circle(), for: .normal)
            btn_NormalDriverOt.setImage(R.image.circleCheck(), for: .normal)
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if isValidInputs() {
            verifyOtp()
        }
    }
        
    func isValidInputs() -> Bool {
        var isValid = true
        var errorMessage: String? = ""
        
        if (txtFirstName.text?.isEmpty)! {
            errorMessage = "Required First Name"
            isValid = false
        } else if (txtLastName.text?.isEmpty)! {
            errorMessage = "Required Last Name"
            isValid = false
        } else if !(Utility.isValidEmail(txtEmail.text!)) {
            errorMessage = "Email Address Not Found"
            isValid = false
        } else if (txtMobile.text?.isEmpty)! {
            errorMessage = "Please Enter Mobile Number"
            isValid = false
        } else if (txtPassword.text?.isEmpty)! {
            errorMessage = "Please Enter the Password!"
            isValid = false
        } else if (txtConfirmPassword.text?.isEmpty)! {
            errorMessage = "Please Confirm Password"
            isValid = false
        } else if (txtPassword.text != txtConfirmPassword.text) {
            errorMessage = "Please Enter Same Password"
            isValid = false
        } else if strCheck.isEmpty {
            errorMessage = "Please Read the Terms And Condition For Proceed"
            isValid = false
        }
        
        if (isValid == false) {
            self.alert(alertmessage: errorMessage ?? "")
        }
        
        return isValid
    }
    
}

extension SignUpVC {
    
    func verifyOtp() {
        var paramDict : [String:AnyObject] = [:]
        paramDict["mobile_with_code"] = "\(self.phoneKey ?? "")\(self.txtMobile.text!)" as AnyObject
        paramDict["mobile"] = self.txtMobile.text! as AnyObject
        paramDict["email"] = self.txtEmail.text! as AnyObject

        print(paramDict)
        
        Api.shared.verifyOtp(self, paramDict) { (response) in
            print(response.code ?? 0)
            self.collectData()
            print(self.collectData())
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
            vc.verificationCode = String(response.code ?? 0)
            vc.verifyCode = String(response.code ?? 0)
            vc.mobileNo = self.txtMobile.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    func collectData() {
        dictSignup["first_name"] = self.txtFirstName.text! as AnyObject
        dictSignup["mobile_witth_country_code"] = self.countryCode as AnyObject
        dictSignup["last_name"] = self.txtLastName.text! as AnyObject
        dictSignup["email"] = self.txtEmail.text! as AnyObject
        dictSignup["lat"] = kAppDelegate.coordinate2.coordinate.latitude as AnyObject
        dictSignup["lon"] = kAppDelegate.coordinate2.coordinate.longitude as AnyObject
        dictSignup["mobile"] = self.txtMobile.text! as AnyObject
        dictSignup["password"] = self.txtPassword.text! as AnyObject
        dictSignup["register_id"] = k.emptyString as AnyObject
        dictSignup["ios_register_id"] = k.iosRegisterId as AnyObject
        dictSignup["type"] = k.userType as AnyObject
        print(dictSignup)
    }
}

extension SignUpVC: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
        self.countryCode = country.phoneCode
        self.countryCodeWithoutPlus = countryCode.replacingOccurrences(of: "+", with: "")
    }
}

extension SignUpVC: CountryPickerViewDataSource {
    
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
