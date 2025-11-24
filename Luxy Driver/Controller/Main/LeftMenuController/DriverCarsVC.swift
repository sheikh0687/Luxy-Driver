//
//  DriverCarsVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import UIKit

class DriverCarsVC: UIViewController {

    @IBOutlet weak var savedCar_TableVw: UITableView!
    
    var arrayDriverVehicleList: [Res_DriverVehicleList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedCar_TableVw.register(UINib(nibName: "SavedCarCell", bundle: nil), forCellReuseIdentifier: "SavedCarCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "My Cars", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        fetchDriverSavedVehicle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_AddCars(_ sender: UIButton) {
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "AddDriverCarsVC") as! AddDriverCarsVC
        self.navigationController?.pushViewController(vC, animated: true)
    }
}

extension DriverCarsVC {
    
    func fetchDriverSavedVehicle() {
        Api.shared.requestToDriverVehicleList(self) { responseData in
            if responseData.count > 0 {
                self.arrayDriverVehicleList = responseData
            } else {
                self.arrayDriverVehicleList = []
            }
            self.savedCar_TableVw.reloadData()
        }
    }
    
    func callForDeleteDriverVehicle(vehicleiD: String)
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["user_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["driver_vehicle_id"] = vehicleiD as AnyObject
        
        print(paramDict)
        
        Api.shared.requestToDeleteDriverVehicle(self, paramDict) { responseData in
            if responseData.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "Vehicle deleted successfully!", delegate: nil, parentViewController: self) { bool in
                    self.fetchDriverSavedVehicle()
                }
            }
        }
    }
}

extension DriverCarsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDriverVehicleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCarCell", for: indexPath) as! SavedCarCell
        
        let obj = self.arrayDriverVehicleList[indexPath.row]
        
        cell.lbl_CarDetails.text = "\(obj.make_name ?? "") Model \(obj.model_name ?? "")\nYear: \(obj.year ?? "")\nColor: \(obj.color_name ?? "")\nStatus: \(obj.status ?? "")"
        
        cell.closureDeleteCar = { [weak self] in
            self?.callForDeleteDriverVehicle(vehicleiD: obj.id ?? "")
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "DriverVehicleDetailVC") as! DriverVehicleDetailVC
        let obj = self.arrayDriverVehicleList[indexPath.row]
        
        var selectedVehicleImages: [String] = []
        
        if let frontImg = obj.vehicle_front_image, Router.BASE_IMAGE_URL != frontImg {
            selectedVehicleImages.append(frontImg)
        } else {
            selectedVehicleImages.append("")
        }
        
        if let backImg = obj.vehicle_back_image, Router.BASE_IMAGE_URL != backImg {
            selectedVehicleImages.append(backImg)
        } else {
            selectedVehicleImages.append("")
        }

        if let rightImg = obj.vehicle_right_side_image, Router.BASE_IMAGE_URL != rightImg {
            selectedVehicleImages.append(rightImg)
        } else {
            selectedVehicleImages.append("")
        }
        
        if let leftImg = obj.vehicle_left_side_image, Router.BASE_IMAGE_URL != leftImg {
            selectedVehicleImages.append(leftImg)
        } else {
            selectedVehicleImages.append("")
        }
        vC.arrayOfVehicelImages = selectedVehicleImages
        vC.strSatus = obj.status ?? ""
        vC.strVehicleDetails = "\(obj.make_name ?? "") Model \(obj.model_name ?? "")\nYear: \(obj.year ?? "")\nColor: \(obj.color_name ?? "")\nStatus: \(obj.status ?? "")"
        self.navigationController?.pushViewController(vC, animated: true)
    }
}
