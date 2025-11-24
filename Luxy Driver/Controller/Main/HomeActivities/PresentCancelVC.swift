//
//  PresentCancelVC.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/12/24.
//

import UIKit

class PresentCancelVC: UIViewController {

    var request_iD:String = ""
    var cloCancelReason: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_Cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_YesCancel(_ sender: UIButton) {
        self.cloCancelReason?()
    }
}
