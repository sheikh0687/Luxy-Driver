//
//  Api.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 03/08/23.
//

import Foundation

class Api: NSObject {
    
    static let shared = Api()
    
    func paramGetUserId() -> [String:AnyObject] {
        var dict : [String:AnyObject] = [:]
        dict["user_id"] = k.userDefault.string(forKey: k.session.userId) as AnyObject
        print(dict)
        return dict
    }
    
    func paramDriverID() -> [String: AnyObject]
    {
        var dict : [String:AnyObject] = [:]
        dict["driver_id"] = k.userDefault.string(forKey: k.session.userId) as AnyObject
        print(dict)
        return dict
    }
    
    func login(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResLogin) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.logIn.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiLogin.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                } else {
                    vc.hideProgressBar()
                    k.userDefault.set(false, forKey: k.session.status)
                    k.userDefault.set(k.emptyString, forKey: k.session.userId)
                    k.userDefault.set(k.emptyString, forKey: k.session.userEmail)
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong")
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getVehicle(_ vc: UIViewController, _ success: @escaping(_ responseData : [ResVehicleList]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getVehicleList.url(), params: self.paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiVehicleList.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func signup(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResSignUp) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.signUp.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiSignUp.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                } else {
                    vc.hideProgressBar()
                    k.userDefault.set(false, forKey: k.session.status)
                    k.userDefault.set(k.emptyString, forKey: k.session.userId)
                    k.userDefault.set(k.emptyString, forKey: k.session.userEmail)
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong")
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func verifyOtp(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResOtp) -> Void) {
        vc.blockUi()
        Service.post(url: Router.otp.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiVerifyOtp.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong!")
                }
                vc.unBlockUi()
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func forgotPassword(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiForgetPassword) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.forgetPassword.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiForgetPassword.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func changePassword(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiBasic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.changePassword.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiBasic.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getProfile(_ vc: UIViewController, _ success: @escaping(_ responseData : ResProfile) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_driver_profile.url(), params: self.paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiProfile.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getUserProfile(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResProfile) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_profile.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiProfile.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_Driver_BankDt(_ vc: UIViewController,_ params: [String : AnyObject],_ success: @escaping(_ responseData : ResProfile) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.updateBankDetails.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiProfile.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_Driver_Info(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?, videos: [String : Data?]?, _ success: @escaping(_ responseData : ResProfile) -> Void) {
        vc.showProgressBar()
        Service.postSingleMedia(url: Router.updateDriverInfo.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiProfile.self, from: response)
                if root.status == "1" {
                    vc.hideProgressBar()
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    //                    vc.alert(alertmessage: root.message ?? R.string.localizable.somethingWentWrong())
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func updatedProfile(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?, videos: [String : Data?]?, _ success: @escaping(_ responseData : ResUpdateProfile) -> Void) {
        vc.showProgressBar()
        Service.postSingleMedia(url: Router.updateProfile.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiUpdatedProfile.self, from: response)
                if root.status == "1" {
                    vc.hideProgressBar()
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.hideProgressBar()
                    //                    vc.alert(alertmessage: root.message ?? R.string.localizable.somethingWentWrong())
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_VehiclePreference(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiBasic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.updateVehiclePreferences.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiBasic.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getHistory(_ vc: UIViewController, _ success: @escaping(_ responseData : [ResHistory]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getHistory.url(), params: self.paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiHistory.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func giveRating(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiRating) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.addRating.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiRating.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func updateStatus(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiDriverStatus) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.updateStatus.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiDriverStatus.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getPendingDriverReq(_ vc: UIViewController, _ success: @escaping(_ responseData : [ResPendingRequest]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getPendingRequest.url(), params: self.paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiDriverPendingReq.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func cancelRequest(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResCancelRequest) -> Void) {
        Service.post(url: Router.cancelRequest.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiCancelRequest.self, from: response)
                if let result = root.result {
                    success(result)
                }
            } catch {
                print(error)
            }
            vc.unBlockUi()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func getActiveDriverReq(_ vc: UIViewController, _ success: @escaping(_ responseData : ResActiveReq) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getActiveRequest.url(), params: self.paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiActiveReq.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getSchedule(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiSchedule) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getSchedule.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiSchedule.self, from: response)
                print(response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                } else {
                    print("Something went wrong!")
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func get_UserLevel(_ vc: UIViewController,_ success: @escaping(_ responseData : Res_UserLevel) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_user_level.url(), params: paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_UserLevel.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                        vc.hideProgressBar()
                    }
                } else {
                    //                    vc.alert(alertmessage: root.message ?? "Something Went Wrong!")
                    print("Something went wrong!")
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func get_DriverEarnings(_ vc: UIViewController,_ success: @escaping(_ responseData : Api_DriverEarnings) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_driver_total_earning.url(), params: paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_DriverEarnings.self, from: response)
                if root.result != nil {
                    vc.hideProgressBar()
                    success(root)
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    
    func updateDriverStatus(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResAcceptRequest) -> Void) {
        Service.post(url: Router.updateRequestStatus.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiAcceptRequest.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                }
            } catch {
                print(error)
            }
            vc.unBlockUi()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func update_RequestTimer(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : Res_RequestTime) -> Void) {
        Service.post(url: Router.update_request_timer_status.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_RequestTimeline.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "")
                }
            } catch {
                print(error)
            }
            vc.unBlockUi()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    
    func makeComplaint(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ApiFeedback) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.addComplaint.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiFeedback.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getNotification(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : [ResNotification]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getNotification.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiNotification.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getChat(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : [ResChat]) -> Void) {
        Service.post(url: Router.getChat.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiChat.self, from: response)
                if let result = root.result {
                    success(result)
                }
            } catch {
                print(error)
            }
            vc.unBlockUi()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func getWalletRequest(_ vc: UIViewController, _ success: @escaping(_ responseData : ResWallet) -> Void) {
        Service.post(url: Router.getWalletRequest.url(), params: self.paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiWalletAmount.self, from: response)
                if let result = root.result {
                    success(result)
                }
            } catch {
                print(error)
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
        }
    }
    
    
    func addRequest(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResAddRequest) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.addWalletRequest.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiAddRequest.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func sendChat(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?,videos: [String : Data?]?, _ success: @escaping(_ responseData : ResSendChat) -> Void) {
        vc.blockUi()
        Service.postSingleMedia(url: Router.sendChat.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock:  { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiSendChat.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong")
                }
            } catch {
                print(error)
            }
            vc.unBlockUi()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.unBlockUi()
        }
    }
    
    func add_Confirm_Stop(_ vc: UIViewController, _ params: [String: AnyObject], _ success: @escaping(_ responseData : ResConfirmStop) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.addConfirmStop.url(), params: params, method: .get, vc: vc, successBlock: { (response) in
            print(params)
            do {
                let decoder = JSONDecoder()
                print("Response received: \(String(data: response, encoding: .utf8) ?? "Unable to convert data to string")")
                let root = try decoder.decode(ApiConfirmStop.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func deleteAccount(_ vc: UIViewController, _ success: @escaping(_ responseData : ApiDeleteAccount) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.deleteAccount.url(), params: self.paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiDeleteAccount.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func getPolicy(_ vc: UIViewController, _ success: @escaping(_ responseData : ResPolicy) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.getPolicy.url(), params: self.paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiPolicy.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func update_LocationWithAwayTime(_ vc: UIViewController,_ param : [String : AnyObject], _ success: @escaping(_ responseData : Api_UpdateLocation) -> Void) {
        //        vc.showProgressBar()
        Service.post(url: Router.update_location_with_away_time.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_UpdateLocation.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToCancelReason(_ vc: UIViewController, _ success: @escaping(_ responseData : [Res_CancelReason]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_request_cancel_reason.url(), params: self.paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_CancelReason.self, from: response)
                if let result = root.result {
                    success(result)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToFinalCalculation(_ vc: UIViewController,_ param:[String : AnyObject],_ success: @escaping(_ responseData : Api_FareAmountCalculation) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.final_fare_calculation.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_FareAmountCalculation.self, from: response)
                if root.result != nil {
                    vc.hideProgressBar()
                    success(root)
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func fetchRequestDetails(_ vc: UIViewController,_ param: [String : AnyObject], _ success: @escaping(_ responseData : Api_RequestDetails) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.get_request_details.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            print(response)
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_RequestDetails.self, from: response)
                print(root)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                print(error)
                vc.hideProgressBar()
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func fetchThanksMessage(_ vc: UIViewController,_ param: [String : AnyObject] , _ success: @escaping(_ responseData : ApiBasic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.say_thank_you.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiBasic.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToDriverVehicleList(_ vc: UIViewController, _ success: @escaping(_ responseData : [Res_DriverVehicleList]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.driver_vehicle_list.url(), params: paramDriverID(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_DriverVehicleList.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToDeleteDriverVehicle(_ vc: UIViewController,_ param: [String : AnyObject] , _ success: @escaping(_ responseData : ApiBasic) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.delete_driver_vehicle.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(ApiBasic.self, from: response)
                if root.result != nil {
                    success(root)
                    vc.hideProgressBar()
                }
            } catch {
                vc.hideProgressBar()
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToMakeCar(_ vc: UIViewController, _ success: @escaping(_ responseData : [Res_MakeCar]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.car_make.url(), params: paramGetUserId(), method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_MakeCar.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestForCarModel(_ vc: UIViewController,_ param: [String : AnyObject] , _ success: @escaping(_ responseData : [Res_CarModel]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.car_model.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_CarModel.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestForCarModelColor(_ vc: UIViewController,_ param: [String : AnyObject] , _ success: @escaping(_ responseData : [Res_CarColorResource]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.car_model_color.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_CarColorResource.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToAddDriverVehicle(_ vc: UIViewController, _ params: [String: String], images: [String : UIImage?]?,videos: [String : Data?]?, _ success: @escaping(_ responseData : Res_AddDriverVehicle) -> Void) {
        vc.showProgressBar()
        Service.postSingleMedia(url: Router.add_driver_vehicle.url(), params: params, imageParam: images, videoParam: videos, parentViewController: vc, successBlock:  { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_AddDriverVehicle.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                } else {
                    vc.alert(alertmessage: root.message ?? "Something Went Wrong")
                }
                vc.hideProgressBar()
            } catch {
                print(error)
            }
            vc.hideProgressBar()
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
    
    func requestToCarModelVehicle(_ vc: UIViewController,_ param: [String : AnyObject] , _ success: @escaping(_ responseData : [Res_CarModelVehicle]) -> Void) {
        vc.showProgressBar()
        Service.post(url: Router.driver_car_model_vehicle.url(), params: param, method: .get, vc: vc, successBlock: { (response) in
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Api_CarModelVehicle.self, from: response)
                if root.status == "1" {
                    if let result = root.result {
                        success(result)
                    }
                }
                vc.hideProgressBar()
            } catch {
                print(error)
                vc.hideProgressBar()
            }
        }) { (error: Error) in
            vc.alert(alertmessage: error.localizedDescription)
            vc.hideProgressBar()
        }
    }
}
