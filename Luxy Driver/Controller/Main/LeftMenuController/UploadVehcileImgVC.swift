//
//  UploadVehcileImgVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import UIKit

class UploadVehcileImgVC: UIViewController {

    var frontSideImage:UIImage? = nil
    var backSideImage:UIImage? = nil
    var rightSideImage:UIImage? = nil
    var leftSideImage:UIImage? = nil
    
    var cloVehcileImages:((_ frontSideImg: UIImage,_ backSideImg: UIImage,_ rightSideImg: UIImage,_ leftSideImg: UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btn_UploadFrontImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.frontSideImage = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btn_UploadBackImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.backSideImage = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }

    @IBAction func btn_UploadFrontRightImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.rightSideImage = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }

    @IBAction func btn_UploadLeftImg(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.leftSideImage = image
            sender.contentMode = .scaleToFill
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func btn_Submit(_ sender: UIButton) {
        if frontSideImage == nil {
            self.alert(alertmessage: "Please upload the front image!")
        } else if backSideImage == nil {
            self.alert(alertmessage: "Please upload the back image!")
        } else if rightSideImage == nil {
            self.alert(alertmessage: "Please upload the right image!")
        } else if leftSideImage == nil {
            self.alert(alertmessage: "Please upload the left image!")
        } else {
            self.cloVehcileImages?(frontSideImage!, backSideImage!, rightSideImage!, leftSideImage!)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
