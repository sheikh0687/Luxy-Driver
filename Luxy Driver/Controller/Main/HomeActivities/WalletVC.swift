//
//  WalletVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var lblAvailbleAmount: UILabel!
    @IBOutlet weak var lblRequest: UILabel!
    @IBOutlet weak var lblTotalRequest: UILabel!
    
    var strWalletAmount:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Wallet", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.profile()
//        self.walletRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func profile()
    {
        Api.shared.getProfile(self) { responseData in
            let obj = responseData
            self.lblAvailbleAmount.text = "\(k.currency) \(obj.wallet ?? "")"
            self.strWalletAmount = obj.wallet ?? ""
        }
    }
    
    func walletRequest()
    {
        Api.shared.getWalletRequest(self) { responseData in
            let obj = responseData
            print(obj.status ?? "")
            if obj.status == "Pending" {
                self.lblRequest.text = "You have 1 pending withdraw request for $ 72.24"
                self.lblTotalRequest.text = "Pending withdraw request"
            } else {
                self.lblRequest.text = "0.00"
                self.lblTotalRequest.text = "0 pending withdraw request"
            }
        }
    }
    
    @IBAction func btnSendRequest(_ sender: UIButton)
    {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "WithdrawAmountVC") as! WithdrawAmountVC
        vc.amount = self.strWalletAmount
        self.navigationController?.pushViewController(vc, animated: true)

//        Api.shared.getWalletRequest(self) { responseData in
//            let obj = responseData
//            
//            if obj.status == "Pending"
//            {
//                self.alert(alertmessage: "Already request sended!")
//            }else
//            {
//            }
//        }
    }
}


