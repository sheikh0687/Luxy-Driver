//
//  QRCodeVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 16/01/24.
//

import UIKit

class QRCodeVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view_Image: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "QR Code", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.driver_Profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        toggleLeft()
    }
    
    func driver_Profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            if Router.BASE_IMAGE_URL != obj.unique_code_image {
                Utility.setImageWithSDWebImage(obj.unique_code_image ?? "", self.img)
            } else {
                self.img.image = R.image.placeholder()
            }
        }
    }
    
    @IBAction func btn_Save(_ sender: UIButton) {
        guard let snapshot = view_Image.snapshotViewHierarchy() else {
            return
        }
        // save photo
        UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil)
        Utility.doShareImage(snapshot, self)

    }
}
