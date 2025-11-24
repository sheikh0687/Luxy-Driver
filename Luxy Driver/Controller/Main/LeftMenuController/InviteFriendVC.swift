//
//  InviteFriendVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class InviteFriendVC: UIViewController {

    @IBOutlet weak var lblCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Invite Friends", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        profile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func leftClick() {
        toggleLeft()
    }

    func profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
//            self.lblCode.text = obj.code ?? ""
        }
    }
    
    @IBAction func btnInvite(_ sender: UIButton)
    {
        Utility.doShare("www.google.com", "www.google.com", self)
    }
}
