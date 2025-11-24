//
//  PrivacyPolicyVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var lblPolicy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Privacy Policy", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.termsAndCondition()
    }
    
    
    override func leftClick() {
        toggleLeft()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func termsAndCondition()
    {
        Api.shared.getPolicy(self) { responseData in
            let obj = responseData
            let httml = obj.privacy ?? ""
            if let attributedData = httml.htmlAttributedString3{
                self.lblPolicy.attributedText = attributedData
            }
        }
    }
}
