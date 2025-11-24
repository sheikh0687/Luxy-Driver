//
//  AppDelegate.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/12/23.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import SlideMenuControllerSwift
import AVFoundation

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    var coordinate1 = CLLocation(latitude: 0.0, longitude: 0.0)
    var coordinate2 = CLLocation(latitude: 0.0, longitude: 0.0)
    var CURRENT_LAT = ""
    var CURRENT_LON = ""

    let notificationCenter = UNUserNotificationCenter.current()
    
    var audioPlayer: AVAudioPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        LocationManager.sharedInstance.delegate = kAppDelegate
        LocationManager.sharedInstance.startUpdatingLocation()
        Switcher.updateRootVC()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.testPlaySound()
//        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        notificationCenter.delegate = self
        self.configureNotification()
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .black
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func testPlaySound()
    {
        playCustomSound(strSound: "booking_sound_file")
    }
    
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error While fetching the registration token \(error)")
            } else if let token = token {
                print("Firebase registration token is \(token)")
                k.iosRegisterId = token
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        k.iosRegisterId = deviceTokenString
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
            print(info)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("Notification received: \(userInfo)")
        
        // Check if sound key is present
        if let aps = userInfo["aps"] as? [String: AnyObject], let driverStatus = aps["alert"] as? String {
            if driverStatus == "You have a new trip request" {
                playCustomSound(strSound: "booking_sound_file")
                handleNewUserRequest(userInfo)
            } else if driverStatus == "Tip provided by user" {
                handleCurrentStatus(userInfo)
                playCustomSound(strSound: "text_sound_file")
            } else if driverStatus == "New stop location added" {
                handleCurrentStatus(userInfo)
                playCustomSound(strSound: "text_sound_file")
            } else if driverStatus == "Passenger update dropoff location" {
                handleCurrentStatus(userInfo)
                playCustomSound(strSound: "text_sound_file")
            } else {
                Switcher.updateRootVC()
                playCustomSound(strSound: "text_sound_file")
            }
        } else {
            print("alert key is missing.")
        }
        
        completionHandler([.alert])
    }
    
    func playCustomSound(strSound:String) {
        guard let soundURL = Bundle.main.url(forResource: strSound, withExtension: "mpeg") else {
            print("Custom sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing custom sound: \(error.localizedDescription)")
        }
    }
    
    func handleNewUserRequest(_ userInfo: Dictionary<AnyHashable, Any>) {
        
        DispatchQueue.main.async {
            // Ensure we get the top-most view controller
            if let topVC = UIApplication.topViewController() {
                if let slideMenuController = topVC as? SlideMenuController,
                   let navController = slideMenuController.mainViewController as? UINavigationController,
                   let rootVC = navController.viewControllers.first as? HomeVC {
                    // If HomeVC is the root of the navigation stack
                    rootVC.fetchNewRequest()
                } else if let homeVC = topVC as? HomeVC {
                    // If HomeVC is directly the top view controller
                    homeVC.fetchNewRequest()
                } else {
                    print("HomeVC is not active!")
                }
            }
        }
    }
    
    func handleCurrentStatus(_ userInfo: Dictionary<AnyHashable, Any>) {
        if UIApplication.topViewController() != nil {
            DispatchQueue.main.async {
                if let rVC = UIApplication.topViewController(), rVC is ArrivedVC {
                    let rootVC = rVC as! ArrivedVC
                    rootVC.activeRequest()
                } else {
                    print("!!!!!")
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let info = userInfo as? Dictionary<String, AnyObject> {
            let title = userInfo["title"] ?? ""
            redirectNotification(info, title as! String)
        }
    }
    
    func redirectNotification(_ userInfo: Dictionary<String, AnyObject>,_ tittle: String) {
       
        if tittle == "You have a new trip request" {
            if UIApplication.topViewController() != nil {
                DispatchQueue.main.async {
                    Switcher.updateRootVC()
                }
            }
        } else if tittle == "Tip provided by user" {
            redirectToDriverUpdateVC()
        } else if tittle == "New stop location added" {
            redirectToDriverUpdateVC()
        } else if tittle == "Passenger update dropoff location" {
            redirectToDriverUpdateVC()
        } else {
            Switcher.updateRootVC()
        }
    }

    func redirectToDriverUpdateVC()
    {
        let visibleVC = UIApplication.topViewController()
        let vC = R.storyboard.main().instantiateViewController(withIdentifier: "ArrivedVC") as! ArrivedVC
        visibleVC?.navigationController?.pushViewController(vC, animated: true)
    }
}

extension AppDelegate: LocationManagerDelegate {
    
    func didEnterInCircularArea() {
        print("")
    }
    
    func didExitCircularArea() {
        print("")
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        coordinate2 = currentLocation
        print(coordinate2)
        let distanceInMeters = coordinate1.distance(from: coordinate2) // result is in meters
        if distanceInMeters > 250 {
            CURRENT_LAT = String(currentLocation.coordinate.latitude)
            print(CURRENT_LAT)
            CURRENT_LON = String(currentLocation.coordinate.longitude)
            coordinate1 = currentLocation
            if let _ = UserDefaults.standard.value(forKey: "user_id") {
                //self.updateLatLon()
            }
        }
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("tracing Location Error : \(error.description)")
    }
}
