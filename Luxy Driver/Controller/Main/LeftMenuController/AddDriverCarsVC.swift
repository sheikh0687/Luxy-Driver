//
//  AddDriverCarsVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import UIKit
import DropDown

class AddDriverCarsVC: UIViewController {
    
    @IBOutlet weak var commercialVw: UIStackView!
    @IBOutlet weak var btn_CarMake: UIButton!
    @IBOutlet weak var btn_CarModel: UIButton!
    @IBOutlet weak var btn_CarModelYear: UIButton!
    @IBOutlet weak var btn_CarModelColoriD: UIButton!
    
    @IBOutlet weak var txt_VehicleRegistrationNumber: UITextField!
    @IBOutlet weak var txt_LicensePlateNumber: UITextField!
    
    var arrayAllBrandCar: [Res_MakeCar] = []
    var arrayAllCarModel: [Res_CarModel] = []
    var arrayCarModelColor: [Res_CarColorResource] = []
    var arrayOfCarModelYear: [Year_list] = []
    var arrayOfCarModelYearID: [String] = []
    var arrayOfCarModelYearNames: [String] = []
    
    let dropCarNames: DropDown = DropDown()
    let dropCarModel: DropDown = DropDown()
    let dropCarModelYear: DropDown = DropDown()
    let dropCarModelColor: DropDown = DropDown()
    
    var strMakeiD: String = ""
    var strMakeName:String = ""
    var strModeliD:String = ""
    var strModelName:String = ""
    var strYear:String = ""
    var strColoriD:String = ""
    var strColorName:String = ""
    var strColorImage:String = ""
    var strCommercialType:String = ""
    var strDriverVehicleiD:String = ""
    
    var frontSideImage:UIImage? = nil
    var backSideImage:UIImage? = nil
    var rightSideImage:UIImage? = nil
    var leftSideImage:UIImage? = nil
    
    var vehicleRegImg: UIImage? = nil
    var vehicleInsuranceImg: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Add Car", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        fetchAllCars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_SelectCarName(_ sender: UIButton) {
        dropCarNames.show()
    }
    
    @IBAction func btn_CarModel(_ sender: UIButton) {
        dropCarModel.show()
    }
    
    @IBAction func btn_SelectYear(_ sender: UIButton) {
        dropCarModelYear.show()
    }
    
    @IBAction func btn_Color(_ sender: UIButton) {
        dropCarModelColor.show()
    }
    
    func configureCarNameDropdown() {
        var arrVehicleId:[String] = []
        var arrVehicleName:[String] = []
        for val in self.arrayAllBrandCar {
            arrVehicleId.append(val.id ?? "")
            arrVehicleName.append(val.make ?? "")
        }
        dropCarNames.anchorView = btn_CarMake
        dropCarNames.dataSource = arrVehicleName
        dropCarNames.backgroundColor = .white
        dropCarNames.setupCornerRadius(8)
        dropCarNames.separatorColor = .systemBackground
        dropCarNames.bottomOffset = CGPoint(x: -2, y: 40)
        dropCarNames.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.strMakeiD = arrVehicleId[index]
            self.strMakeName = item
            self.btn_CarMake.setTitle(item, for: .normal)
            self.fetchAllCarModel()
        }
    }
    
    func configureCarModelDropdown() {
        var arrCarModeliD:[String] = []
        var arrCarModelName:[String] = []
        var arrDriverVehicleiD:[String] = []
        var arrCarYear: [[Year_list]] = []
        for val in self.arrayAllCarModel {
            arrCarModeliD.append(val.id ?? "")
            arrCarModelName.append(val.model ?? "")
            arrDriverVehicleiD.append(val.vehicle_id ?? "")
            arrCarYear.append(val.year_list ?? [])
        }
        dropCarModel.anchorView = btn_CarModel
        dropCarModel.dataSource = arrCarModelName
        dropCarModel.backgroundColor = .white
        dropCarModel.setupCornerRadius(8)
        dropCarModel.separatorColor = .systemBackground
        dropCarModel.bottomOffset = CGPoint(x: -2, y: 40)
        dropCarModel.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.strModeliD = arrCarModeliD[index]
            self.strDriverVehicleiD = arrDriverVehicleiD[index]
            self.strModelName = item
            self.btn_CarModel.setTitle(item, for: .normal)
            
            self.arrayOfCarModelYear = arrCarYear[index]
            self.arrayOfCarModelYearID = self.arrayOfCarModelYear.compactMap { $0.id }
            self.arrayOfCarModelYearNames = self.arrayOfCarModelYear.compactMap { $0.year }
            
            self.configureCarModelYearDropdown()
            self.fetchAllCarModelColor()
        }
    }
    
    func configureCarModelYearDropdown() {
        dropCarModelYear.anchorView = btn_CarModelYear
        dropCarModelYear.dataSource = arrayOfCarModelYearNames
        dropCarModelYear.backgroundColor = .white
        dropCarModelYear.setupCornerRadius(8)
        dropCarModelYear.separatorColor = .systemBackground
        dropCarModelYear.bottomOffset = CGPoint(x: -2, y: 40)
        dropCarModelYear.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.strYear = arrayOfCarModelYearID[index]
            self.btn_CarModelYear.setTitle(item, for: .normal)
        }
    }
    
    func configureCarModelColorDropdown() {
        var arrCarModelColoriD:[String] = []
        var arrCarModelColorName:[String] = []
        var arrCarModelImage: [String] = []
        for val in self.arrayCarModelColor {
            arrCarModelColoriD.append(val.id ?? "")
            arrCarModelColorName.append(val.color ?? "")
            arrCarModelImage.append(val.image ?? "")
        }
        dropCarModelColor.anchorView = btn_CarModelColoriD
        dropCarModelColor.dataSource = arrCarModelColorName
        dropCarModelColor.backgroundColor = .white
        dropCarModelColor.setupCornerRadius(8)
        dropCarModelColor.separatorColor = .systemBackground
        dropCarModelColor.bottomOffset = CGPoint(x: -2, y: 40)
        dropCarModelColor.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.strColoriD = arrCarModelColoriD[index]
            self.strColorImage = arrCarModelImage[index]
            self.strColorName = item
            self.btn_CarModelColoriD.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func btn_VehicleRegImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.vehicleRegImg = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btn_VehicleInsurance(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.vehicleInsuranceImg = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }

    }
    
    @IBAction func btn_AirportCodeFront(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btn_AirportCodeBack(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }

    @IBAction func btn_UploadVehicleImg(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "UploadVehcileImgVC") as! UploadVehcileImgVC
        vC.cloVehcileImages = { front, back, right, left in
            self.frontSideImage = front
            self.backSideImage = back
            self.rightSideImage = right
            self.leftSideImage = left
        }
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func btn_Commercial(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(R.image.uncheck(), for: .normal)
            self.commercialVw.isHidden = true
            self.strCommercialType = "No"
        } else {
            sender.isSelected = true
            sender.setImage(R.image.checked(), for: .normal)
            self.commercialVw.isHidden = false
            self.strCommercialType = "Yes"
        }
    }
    
    func isValidInputs() -> Bool {
        var isValid : Bool = true;
        var errorMessage : String = ""
        
        if strMakeiD.isEmpty {
            errorMessage = "Please select car make."
            isValid = false
        } else if strModeliD.isEmpty {
            errorMessage = "Please select car model"
            isValid = false
        } else if strColoriD.isEmpty {
            errorMessage = "Please select car color"
            isValid = false
        } else if (txt_VehicleRegistrationNumber.text!.isEmpty) {
            errorMessage = "Please enter registration number"
            isValid = false
        } else if (txt_LicensePlateNumber.text!.isEmpty) {
            errorMessage = "Please enter license plate number"
            isValid = false
        } else if vehicleRegImg == nil {
            errorMessage = "Please upload registration image"
            isValid = false
        } else if frontSideImage == nil {
            errorMessage = "Please upload vehicle front side image"
            isValid = false
        } else if backSideImage == nil {
            errorMessage = "Please upload vehicle back side image"
            isValid = false
        } else if frontSideImage == nil {
            errorMessage = "Please upload vehicle front side image"
            isValid = false
        } else if leftSideImage == nil {
            errorMessage = "Please upload vehicle left side image"
            isValid = false
        }
        
        if (isValid == false) {
            self.alert(alertmessage: errorMessage)
        }
        
        return isValid
    }
    
    @IBAction func btn_Submit(_ sender: UIButton) {
        if isValidInputs() {
            callToAddDriverCar()
        }
    }
}

extension AddDriverCarsVC {
    
    func fetchAllCars() {
        Api.shared.requestToMakeCar(self) { responseData in
            if responseData.count > 0 {
                self.arrayAllBrandCar = responseData
            } else {
                self.arrayAllBrandCar = []
            }
            DispatchQueue.main.async {
                self.configureCarNameDropdown()
            }
        }
    }
    
    func fetchAllCarModel() {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["make_id"] = strMakeiD as AnyObject?
        
        Api.shared.requestForCarModel(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.arrayAllCarModel = responseData
            } else {
                self.arrayAllCarModel = []
            }
            DispatchQueue.main.async {
                self.configureCarModelDropdown()
            }
        }
    }
    
    func fetchAllCarModelColor() {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["car_model_id"] = strModeliD as AnyObject?
        
        print(paramDict)
        
        Api.shared.requestForCarModelColor(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.arrayCarModelColor = responseData
            } else {
                self.arrayCarModelColor = []
            }
            DispatchQueue.main.async {
                self.configureCarModelColorDropdown()
            }
        }
    }
    
    func callToAddDriverCar() {
        var paramDict: [String : String] = [:]
        paramDict["driver_id"] = k.userDefault.value(forKey: k.session.userId) as? String
        paramDict["registration_no"] = txt_VehicleRegistrationNumber.text
        paramDict["vehicle_id"] = strDriverVehicleiD
        paramDict["make_id"] = strMakeiD
        paramDict["make_name"] = strMakeName
        paramDict["model_id"] = strModeliD
        paramDict["model_name"] = strModelName
        paramDict["year"] = strYear
        paramDict["color_id"] = strColoriD
        paramDict["color_name"] = strColorName
        paramDict["color_image"] = strColorImage
        paramDict["license_plate_number"] = txt_LicensePlateNumber.text
        paramDict["vehicle_registration_number"] = txt_VehicleRegistrationNumber.text
        paramDict["commercial_type"] = strCommercialType
        paramDict["vehicle_name"] = k.emptyString
        paramDict["vehicle_work_type"] = k.emptyString
        
        print(paramDict)
        
        var paramImgDict: [String : UIImage] = [:]
        paramImgDict["vehicle_front_image"] = frontSideImage
        paramImgDict["vehicle_back_image"] = backSideImage
        paramImgDict["vehicle_right_side_image"] = rightSideImage
        paramImgDict["vehicle_left_side_image"] = leftSideImage
        
        print(paramImgDict)
        
        Api.shared.requestToAddDriverVehicle(self, paramDict, images: paramImgDict, videos: [:]) { responseData in
            Utility.showAlertWithAction(withTitle: k.appName, message: "Vehicle Added Successfully!", delegate: nil, parentViewController: self) { bool in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
