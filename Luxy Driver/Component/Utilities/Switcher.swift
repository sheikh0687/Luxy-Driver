//
//  Switcher.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 03/08/23.
//

import Foundation

import UIKit
import SlideMenuControllerSwift

class Switcher {
    
    static func updateRootVC() {
        
        let status = k.userDefault.bool(forKey: k.session.status)
        
        if status {
            let mainViewController = R.storyboard.main().instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let vc = UINavigationController(rootViewController: mainViewController)
            let leftViewController = R.storyboard.main().instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
            let rootVC = SlideMenuController(mainViewController: vc, leftMenuViewController: leftViewController)
            kAppDelegate.window?.rootViewController = rootVC
            kAppDelegate.window?.makeKeyAndVisible()
        } else {
            if logout {
                let rootVC = R.storyboard.main().instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav = UINavigationController(rootViewController: rootVC)
                nav.isNavigationBarHidden = false
                kAppDelegate.window!.rootViewController = nav
                kAppDelegate.window?.makeKeyAndVisible()
            } else {
                let rootVC = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController(rootViewController: rootVC)
                nav.isNavigationBarHidden = false
                kAppDelegate.window!.rootViewController = nav
                kAppDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}
