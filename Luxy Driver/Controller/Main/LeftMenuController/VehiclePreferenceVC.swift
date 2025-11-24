//
//  VehiclePreferenceVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/02/24.
//

import UIKit
import DropDown

class VehiclePreferenceVC: UIViewController {
    
    @IBOutlet weak var vehicle_Collection: UICollectionView!
    @IBOutlet weak var collection_Height: NSLayoutConstraint!
    @IBOutlet weak var btn_PickAvailableOptionOt: UIButton!
    @IBOutlet weak var lbl_VehicleUpdate: UILabel!
    
    var arrayVehicleList: [Res_CarModelVehicle] = []
    var arrayAvailableVehicle: [Res_DriverVehicleList] = []
    
    var vehicle_Id: [Int] = []
    var vehicle_Name: [String] = []
    var vehicle_type: [String] = []
    
    var is_Selected: Bool = true
    var vehicle_Statuss = ""
    var strDriverVehicleiD:String = ""
    var strYear:String = ""
    
    let dropAvailableVehicle = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vehicle_Collection.register(UINib(nibName: "PreferenceCell", bundle: nil),forCellWithReuseIdentifier: "PreferenceCell")
        //        vehicle_Lists()
        vehicle_Collection.isMultipleTouchEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        fetchDriverAvailableVehicle()
    }
    
    @IBAction func btn_SelectAvailableOption(_ sender: UIButton) {
        dropAvailableVehicle.show()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if vehicle_Id.isEmpty {
            self.alert(alertmessage: "Please select your vehicle type!")
        } else {
            update_VehiclePref()
        }
    }
    
    func configureAvailableVehicleDropdown() {
        var arrVehicleId:[String] = []
        var arrVehicleName:[String] = []
        var arrVehicleYear: [String] = []
        for val in self.arrayAvailableVehicle {
            arrVehicleId.append(val.vehicle_id ?? "")
            arrVehicleName.append("\(val.make_name ?? "") \(val.model_name ?? "")")
            arrVehicleYear.append(val.year ?? "")
        }
        dropAvailableVehicle.anchorView = btn_PickAvailableOptionOt
        dropAvailableVehicle.dataSource = arrVehicleName
        dropAvailableVehicle.backgroundColor = .white
        dropAvailableVehicle.setupCornerRadius(8)
        dropAvailableVehicle.separatorColor = .systemBackground
        dropAvailableVehicle.bottomOffset = CGPoint(x: -2, y: 40)
        dropAvailableVehicle.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.strDriverVehicleiD = arrVehicleId[index]
            self.strYear = arrVehicleYear[index]
            self.btn_PickAvailableOptionOt.setTitle(item, for: .normal)
            self.lbl_VehicleUpdate.text = item
            fetchDriverCarModelVehicle()
        }
    }
}

extension VehiclePreferenceVC {
    
    func fetchDriverAvailableVehicle() {
        Api.shared.requestToDriverVehicleList(self) { responseData in
            if responseData.count > 0 {
                self.arrayAvailableVehicle = responseData
            } else {
                self.arrayAvailableVehicle = []
            }
            self.configureAvailableVehicleDropdown()
        }
    }
    
    func fetchDriverCarModelVehicle() {
        
        var paramDict: [String : AnyObject] = [:]
        paramDict["driver_id"] = k.userDefault.value(forKey: k.session.userId) as AnyObject?
        paramDict["driver_vehicle_id"] = strDriverVehicleiD as AnyObject?
        paramDict["year"] = strYear as AnyObject?
        
        print(paramDict)
        
        Api.shared.requestToCarModelVehicle(self, paramDict) { responseData in
            if responseData.count > 0 {
                self.arrayVehicleList = responseData
                let numberOfItemsInRow = 2 // You can adjust this based on your layout
                let numberOfRows = (responseData.count + numberOfItemsInRow - 1) / numberOfItemsInRow
                print(numberOfRows)
                let cellHeight: CGFloat = 155
                self.collection_Height.constant = CGFloat(numberOfRows) * cellHeight
            } else {
                self.arrayVehicleList = []
            }
            self.vehicle_Collection.reloadData()
        }
    }
    
    
    func update_VehiclePref()
    {
        var paramDict: [String : AnyObject] = [:]
        paramDict["driver_id"]              = k.userDefault.value(forKey: k.session.userId) as AnyObject
        paramDict["vehicle_id"]             = vehicle_Id.map { String($0) }.joined(separator: ",") as AnyObject
        paramDict["vehicle_name"]           = vehicle_Name.joined(separator: ",") as AnyObject
        paramDict["vehicle_work_type"]      = vehicle_type.joined(separator: ",") as AnyObject
        paramDict["vehicle_added"]          = vehicle_Statuss as AnyObject
        
        print(paramDict)
        
        Api.shared.update_VehiclePreference(self, paramDict) { responseData in
            if responseData.status == "1" {
                Utility.showAlertWithAction(withTitle: k.appName, message: "Your preference set successfully", delegate: nil, parentViewController: self) { bool in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.alert(alertmessage: "Something went wrong!")
            }
        }
    }
}

extension VehiclePreferenceVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayVehicleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreferenceCell", for: indexPath) as! PreferenceCell
        let obj = self.arrayVehicleList[indexPath.item]
        
        cell.lbl_VehicleName.text = obj.vehicle ?? ""
        cell.lbl_Passenger.text = "Passenger : \(obj.no_of_passenger ?? "")"
        
        if Router.BASE_IMAGE_URL != obj.image {
            Utility.setImageWithSDWebImage(obj.image ?? "", cell.vehicle_Img)
        } else {
            cell.vehicle_Img.image = R.image.placeholder()
        }
        
        if is_Selected {
            if obj.vehicle_added == "Yes" {
                cell.check_Img.image = R.image.checkedYellow()
            } else {
                cell.check_Img.image = R.image.unchecked()
            }
        } else {
            if vehicle_Id.contains(indexPath.item) {
                cell.check_Img.image = R.image.checkedYellow()
            } else {
                cell.check_Img.image = R.image.unchecked()
            }
        }
        return cell
    }
}

extension VehiclePreferenceVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/2, height: 155)
    }
}

extension VehiclePreferenceVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vehicle_Id.contains(indexPath.item) {
            if let index = vehicle_Id.firstIndex(of: indexPath.item) {
                vehicle_Id.remove(at: index)
                vehicle_Name.remove(at: index)
                vehicle_type.remove(at: index)
                is_Selected = false
                vehicle_Statuss = "No"
            }
        } else {
            vehicle_Id.append(indexPath.item)
            print(vehicle_Id)
            vehicle_Name.append(arrayVehicleList[indexPath.item].vehicle ?? "")
            vehicle_type.append(arrayVehicleList[indexPath.item].type ?? "")
            is_Selected = false
            vehicle_Statuss = "Yes"
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
