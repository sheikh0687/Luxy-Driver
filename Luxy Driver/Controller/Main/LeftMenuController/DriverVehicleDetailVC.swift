//
//  DriverVehicleDetailVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import UIKit

class DriverVehicleDetailVC: UIViewController {

    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_VehicleDetails: UILabel!
    @IBOutlet weak var imagesCollectionVe: UICollectionView!
    
    var arrayOfVehicelImages: [String] = []
    var strSatus: String = ""
    var strVehicleDetails: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesCollectionVe.register(UINib(nibName: "VehicleImgCell", bundle: nil), forCellWithReuseIdentifier: "VehicleImgCell")
        self.lbl_Status.text = strSatus
        self.lbl_VehicleDetails.text = strVehicleDetails
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "My Cars", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension DriverVehicleDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfVehicelImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleImgCell", for: indexPath) as! VehicleImgCell
        let obj = self.arrayOfVehicelImages[indexPath.row]
        Utility.setImageWithSDWebImage(obj, cell.vehicleImages)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
