//
//  AddInfoVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 18/12/23.
//

import UIKit
import DropDown

class AddInfoVC: UIViewController {

    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var txtVehicleNum: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var licenseImg: UIButton!
    @IBOutlet weak var companyLogoImg: UIButton!
    @IBOutlet weak var badgeImg: UIButton!
    @IBOutlet weak var vehicleImg: UIButton!
    @IBOutlet weak var registrationImg: UIButton!
    @IBOutlet weak var airportCodesFrontImg: UIButton!
    @IBOutlet weak var airportCodesBackImg: UIButton!
    @IBOutlet weak var commercialVw: UIStackView!
    
    var dropDown = DropDown()
    var arr_Vehicle: [ResVehicleList] = []
    
    var vehicle_Id = ""
    var vehicle_Name = ""
    
    var image1 = UIImage()
    var image2 = UIImage()
    var image3 = UIImage()
    var image4 = UIImage()
    var image5 = UIImage()
    var image6 = UIImage()
    var image7 = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Information", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
//        self.vehicle_List()
//        self.driver_profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func driver_profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.txtVehicleNum.text = obj.registration_no ?? ""
            self.txtCompanyName.text = obj.company_name ?? ""
            self.btnDropDown.setTitle(obj.vehicle_name ?? "", for: .normal)
            self.vehicle_Name = obj.vehicle_name ?? ""
            self.vehicle_Id = obj.vehicle_id ?? ""
            
            if Router.BASE_IMAGE_URL != obj.licence_image {
                Utility.downloadImageBySDWebImage(obj.licence_image ?? "") { image, error in
                    if error == nil {
                        self.licenseImg.setImage(image, for: .normal)
                    } else {
                        self.licenseImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.licenseImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.company_logo {
                Utility.downloadImageBySDWebImage(obj.company_logo ?? "") { image, error in
                    if error == nil {
                        self.companyLogoImg.setImage(image, for: .normal)
                    } else {
                        self.companyLogoImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.companyLogoImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.badge_image {
                Utility.downloadImageBySDWebImage(obj.badge_image ?? "") { image, error in
                    if error == nil {
                        self.badgeImg.setImage(image, for: .normal)
                    } else {
                        self.badgeImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.badgeImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.vehicle_image {
                Utility.downloadImageBySDWebImage(obj.vehicle_image ?? "") { image, error in
                    if error == nil {
                        self.vehicleImg.setImage(image, for: .normal)
                    } else {
                        self.vehicleImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.vehicleImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.registration_image {
                Utility.downloadImageBySDWebImage(obj.registration_image ?? "") { image, error in
                    if error == nil {
                        self.registrationImg.setImage(image, for: .normal)
                    } else {
                        self.registrationImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.registrationImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.air_port_sticker_front {
                Utility.downloadImageBySDWebImage(obj.air_port_sticker_front ?? "") { image, error in
                    if error == nil {
                        self.airportCodesFrontImg.setImage(image, for: .normal)
                    } else {
                        self.airportCodesFrontImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.airportCodesFrontImg.setImage(R.image.placeholder(), for: .normal)
            }
            
            if Router.BASE_IMAGE_URL != obj.air_port_sticker_back {
                Utility.downloadImageBySDWebImage(obj.air_port_sticker_back ?? "") { image, error in
                    if error == nil {
                        self.airportCodesBackImg.setImage(image, for: .normal)
                    } else {
                        self.airportCodesBackImg.setImage(R.image.placeholder(), for: .normal)
                    }
                }
            } else {
                self.airportCodesBackImg.setImage(R.image.placeholder(), for: .normal)
            }
        }
    }
    
    @IBAction func btn_Commercial(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(R.image.uncheck(), for: .normal)
            self.commercialVw.isHidden = true
        } else {
            sender.isSelected = true
            sender.setImage(R.image.checked(), for: .normal)
            self.commercialVw.isHidden = false
        }
    }
    
    @IBAction func btn_MyCars(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "DriverCarsVC") as! DriverCarsVC
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func btnDrop(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    func vehicle_List()
    {
        Api.shared.getVehicle(self) { responseData in
            if responseData.count > 0 {
                self.arr_Vehicle = responseData
            } else {
                self.arr_Vehicle = []
            }
            self.configureVehicleDropdown()
        }
    }
    
    func configureVehicleDropdown() {
        var arrVehicleId:[String] = []
        var arrVehicleName:[String] = []
        for val in self.arr_Vehicle {
            arrVehicleId.append(val.id ?? "")
            arrVehicleName.append(val.vehicle ?? "")
        }
        dropDown.anchorView = self.btnDropDown
        dropDown.dataSource = arrVehicleName
        dropDown.bottomOffset = CGPoint(x: -5, y: 45)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.vehicle_Id = arrVehicleId[index]
            self.vehicle_Name = item
            self.btnDropDown.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func btnDrivingLicense(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image1 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnCompanyLogo(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image2 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnBadgeImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image3 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnVehicleImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image4 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnCarRegistration(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image5 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnAirportCodesFront(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image6 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnAirportCodesBack(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.image7 = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        if vehicle_Name != "" && txtVehicleNum.text != "" && txtCompanyName.text != "" {
            update_Driver_Info()
        } else {
            self.alert(alertmessage: "Please enter the valid details!")
        }
    }
    
    func update_Driver_Info()
    {
        var paramDict: [String : String] = [:]
        paramDict["driver_id"]           = k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["vehicle_id"]          = self.vehicle_Id
        paramDict["vehicle_name"]        = self.vehicle_Name
        paramDict["registration_no"]     = self.txtVehicleNum.text
        paramDict["company_name"]        = self.txtCompanyName.text
        
        print(paramDict)
        
        var paramImgDict: [String : UIImage]     = [:]
        paramImgDict["licence_image"]            = self.image1
        paramImgDict["company_logo"]             = self.image2
        paramImgDict["badge_image"]              = self.image3
        paramImgDict["vehicle_image"]            = self.image4
        paramImgDict["registration_image"]       = self.image5
        paramImgDict["air_port_sticker_front"]   = self.image6
        paramImgDict["air_port_sticker_back"]    = self.image7
        
        print(paramImgDict)

        Api.shared.update_Driver_Info(self, paramDict, images: paramImgDict, videos: [:]) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Information updated successfully!", delegate: nil, parentViewController: self) { bool in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
