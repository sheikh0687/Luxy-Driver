//
//  EditProfileVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit
import CountryPickerView
import SDWebImage

class EditProfileVC: UIViewController {

    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtCountryPicker: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnImg: UIButton!
    
    let cpvInternal = CountryPickerView()
    weak var cpvTextField: CountryPickerView!
    var phoneKey:String?
    var phoneNumber: String = ""
    var countryCode = ""
    var countryCodeWithoutPlus = ""
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCountryView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Edit Profile", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.txtFirstName.text! = obj.first_name ?? ""
            self.txtLastName.text! = obj.last_name ?? ""
            self.txtEmail.text! = obj.email ?? ""
            self.txtMobile.text! = obj.mobile ?? ""
            if obj.image != Router.BASE_IMAGE_URL {
                Utility.downloadImageBySDWebImage(obj.image ?? "") { image, error in
                    if error == nil {
                        self.btnImg.setImage(image, for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func btnImgTapped(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        self.updateProfile()
    }
    
    func updateProfile()
    {
        if self.txtFirstName.hasText && self.txtLastName.hasText && self.txtEmail.hasText && self.txtMobile.hasText {
            Api.shared.updatedProfile(self, self.paramDetail(), images: self.paramImage(), videos: [:]) { responseData in
                Utility.showAlertWithAction(withTitle: k.appName, message: "Profile Updated Successfully!", delegate: nil, parentViewController: self) { boool in
                    self.profile()
                }
            }
        }else{
            self.alert(alertmessage: "Please Enter the required details!")
        }
    }
    
    func paramDetail() -> [String : String]
    {
        let param =
        [
            "user_id": k.userDefault.value(forKey: k.session.userId) as! String,
            "first_name": self.txtFirstName.text!,
            "last_name": self.txtLastName.text!,
            "mobile": self.txtMobile.text!
        ]
        return param
    }
    
    func paramImage() -> [String : UIImage]
    {
        var dictImage: [String : UIImage] = [:]
        dictImage["image"]                = self.image
        return dictImage
    }
}

extension EditProfileVC: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneKey = country.phoneCode
        self.countryCode = country.phoneCode
        self.countryCodeWithoutPlus = countryCode.replacingOccurrences(of: "+", with: "")
    }
}

extension EditProfileVC: CountryPickerViewDataSource {
    
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
