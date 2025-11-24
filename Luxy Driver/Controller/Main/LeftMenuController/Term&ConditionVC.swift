//
//  Term&ConditionVC.swift
//  kargo Buffalo Driver
//
//  Created by Techimmense Software Solutions on 18/10/23.
//

import UIKit

class Term_ConditionVC: UIViewController {

    @IBOutlet weak var lblTerms: UILabel!
    
    var comingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarItem(LeftTitle: "", LeftImage: "black_back", CenterTitle: "Terms And Condition", CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: "", BackgroundImage: "", TextColor: "#ffffff", TintColor: "#ffffff", Menu: "")
        self.termsAndCondition()
    }
    
    override func leftClick() {
        if self.comingFrom == "SignUpVC"{
            self.navigationController?.popViewController(animated: true)
        } else {
            toggleLeft()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func termsAndCondition()
    {
        Api.shared.getPolicy(self) { responseData in
            let obj = responseData
            let httml = obj.term ?? ""
            if let attributedData = httml.htmlAttributedString3 {
                self.lblTerms.attributedText = attributedData
            }
        }
    }
}

//extension String {
//    var htmlAttributedString3 : NSAttributedString? {
//        guard let data = self.data(using: .utf8) else { return nil }
//        do{
//            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html,.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes: nil)
//        }catch{
//            return nil
//        }
//    }
//}
