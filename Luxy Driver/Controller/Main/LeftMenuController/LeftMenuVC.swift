//
//  LeftMenuVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit
import SlideMenuControllerSwift

class LeftMenuVC: UIViewController {
    
    @IBOutlet weak var tableViewOt: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    let identifier = "LeftMenuCell"
    var adminWhatsApp = ""
    
    enum MenuItem: Int, CaseIterable {
        case home
        case myAccount
        case myQrCode
        case myRewards
        case myRating
        case inviteFriends
        case earning
        case makeComplaints
        case changePassword
        case notification
        case privacyPolicy
        case contactUs
        case support
        case termsAndCondition
        case logout
        
        var title: String {
            switch self {
            case .home:
                "Home"
            case .myAccount:
                "My Account"
            case .myQrCode:
                "My QR Code"
            case .myRewards:
                "My Rewards"
            case .myRating:
                "My Rating"
            case .inviteFriends:
                "Invite Friends"
            case .earning:
                "Earning"
            case .makeComplaints:
                "Make Complaints"
            case .changePassword:
                "Change Password"
            case .notification:
                "Notification"
            case .privacyPolicy:
                "Privacy Policy"
            case .contactUs:
                "Contact Us"
            case .support:
                "Support"
            case .termsAndCondition:
                "Terms And Condition"
            case .logout:
                "Logout"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOt.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        self.profile()
    }
    
    func profile()
    {
        Api.shared.getProfile(self)
        { responseData in
            let obj = responseData
            self.lblProfileName.text! = "\(obj.first_name ?? "") \(obj.last_name ?? "")"
            self.adminWhatsApp = obj.mobile ?? ""
            
            if Router.BASE_IMAGE_URL != obj.image {
                Utility.setImageWithSDWebImage(obj.image ?? "", self.imgProfile)
            } else {
                self.imgProfile.image = R.image.profile_ic()
            }
        }
    }
    
    private func viewController(for menuItem: MenuItem) -> UIViewController? {
        switch menuItem {
        case .home:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
        case .myAccount:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC)
        case .myQrCode:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeVC") as! QRCodeVC)
        case .myRewards:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RewardsVC") as! RewardsVC)
        case .myRating:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingDetailVC") as! RatingDetailVC)
        case .inviteFriends:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC)
        case .earning:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarningVC") as! EarningVC)
        case .makeComplaints, .contactUs:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC)
        case .changePassword:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC)
        case .notification:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC)
        case .privacyPolicy:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC)
        case .support:
            // Implement support view controller
            handleSupports()
            return nil
        case .termsAndCondition:
            return UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Term_ConditionVC") as! Term_ConditionVC)
        case .logout:
            handleLogout()
            return nil
        }
    }
    
    private func handleLogout() {
        logout = false
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        Switcher.updateRootVC()
    }
    
    private func handleSupports()
    {
        let whatsAppNumber = self.adminWhatsApp
        print(whatsAppNumber)// Replace with the phone number you want to open the chat with
        
        if let url = URL(string: "https://wa.me/\(whatsAppNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension LeftMenuVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        if let menuItem = MenuItem(rawValue: indexPath.row) {
            cell.lblName.text = menuItem.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension LeftMenuVC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let menuItems = MenuItem(rawValue: indexPath.row) else {return}
        
        if let vc = viewController(for: menuItems) {
            self.slideMenuController()?.changeMainViewController(vc, close: true)
        }
    }
}


