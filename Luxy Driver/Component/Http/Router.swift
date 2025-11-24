//
//  Router.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 03/08/23.
//

import Foundation

enum Router: String {
    
    static let BASE_SERVICE_URL = "https://luxyslc.com/luxy/webservice/"
    static let BASE_IMAGE_URL = "https://luxyslc.com/luxy/uploads/images/"
    static let BASE_URL_POSTCODE = ""
    
    case logIn
    case forgetPassword
    case signUp
    case otp

    case get_profile
    case get_driver_profile
    case updateProfile
    case updateStatus
    case updateBankDetails
    case updateDriverInfo
    case updateVehiclePreferences
    
    case getAddress
    case getHistory
    case getPendingRequest
    case getVehicleList
    
    case getActiveRequest
    case getNotification
    case getWalletRequest
    case getSchedule
    case get_user_level
    case get_driver_total_earning
    case get_request_cancel_reason
    case get_request_details
    case driver_car_model_vehicle
    
    case deleteAddress
    case changePassword
    case cancelRequest
    case deleteAccount
    case update_request_timer_status
    case update_location_with_away_time
    case final_fare_calculation
    
    case addAddress
    case addRating
    case addComplaint
    case addWalletRequest
    case addConfirmStop
    case add_driver_vehicle
    
    case getChat
    case sendChat
    case getPolicy
    case say_thank_you
    case driver_vehicle_list
    
    case car_make
    case car_model
    case car_model_color
    
    case updateRequestStatus
    
    case delete_driver_vehicle
    
    public func url() -> String {
        switch self {
        case .logIn:
            return Router.oAuthRoute(path: "login")
        case .forgetPassword:
            return Router.oAuthRoute(path: "forgot_password")
        case .signUp:
            return Router.oAuthRoute(path: "signup")
        case .otp:
            return Router.oAuthRoute(path: "verify_number")
            
        case .get_profile:
            return Router.oAuthRoute(path: "get_profile")
        case .get_driver_profile:
            return Router.oAuthRoute(path: "get_driver_profile")
        case .updateProfile:
            return Router.oAuthRoute(path: "driver_update_profile")
        case .updateStatus:
            return Router.oAuthRoute(path: "update_driver_status")
        case .updateBankDetails:
            return Router.oAuthRoute(path: "driver_update_bank_details")
        case .updateDriverInfo:
            return Router.oAuthRoute(path: "driver_update_information")
        case .updateVehiclePreferences:
            return Router.oAuthRoute(path: "add_vehicle_prefrence")
            
        case .getAddress:
            return Router.oAuthRoute(path: "get_user_address")
        case .getHistory:
            return Router.oAuthRoute(path: "get_driver_complete_request")
        case .getPendingRequest:
            return Router.oAuthRoute(path: "get_driver_pending_request")
        case .getVehicleList:
            return Router.oAuthRoute(path: "vehicle_list")
        case .getActiveRequest:
            return Router.oAuthRoute(path: "get_driver_active_request")
        case .getNotification:
            return Router.oAuthRoute(path: "get_notification_list")
        case .getWalletRequest:
            return Router.oAuthRoute(path: "get_withdraw_request")
        case .getSchedule:
            return Router.oAuthRoute(path: "get_driver_schedule_request")
        case .get_user_level:
            return Router.oAuthRoute(path: "get_user_level")
        case .get_driver_total_earning:
            return Router.oAuthRoute(path: "get_driver_total_earning")
        case .get_request_cancel_reason:
            return Router.oAuthRoute(path: "get_request_cancel_reason")
        case .get_request_details:
            return Router.oAuthRoute(path: "get_request_details")
            
        case .deleteAddress:
            return Router.oAuthRoute(path: "delete_user_address")
        case .changePassword:
            return Router.oAuthRoute(path: "change_password")
        case .cancelRequest:
            return Router.oAuthRoute(path: "add_rejected_request")
        case .deleteAccount:
            return Router.oAuthRoute(path: "delete_user_account")
        case .update_request_timer_status:
            return Router.oAuthRoute(path: "update_request_timer_status")
        case .update_location_with_away_time:
            return Router.oAuthRoute(path: "update_location_with_away_time")
        case .final_fare_calculation:
            return Router.oAuthRoute(path: "final_fare_calculation")
            
        case .addAddress:
            return Router.oAuthRoute(path: "add_user_address")
        case .addRating:
            return Router.oAuthRoute(path: "give_rating_to_user")
        case .addComplaint:
            return Router.oAuthRoute(path: "send_feedback")
        case .addWalletRequest:
            return Router.oAuthRoute(path: "add_withdraw_request")
        case .addConfirmStop:
            return Router.oAuthRoute(path: "set_waiting_start_end_time")
        case .add_driver_vehicle:
            return Router.oAuthRoute(path: "add_driver_vehicle")
            
        case .getChat:
            return Router.oAuthRoute(path: "get_conversation_detail")
        case .sendChat:
            return Router.oAuthRoute(path: "insert_chat")
            
        case .updateRequestStatus:
            return Router.oAuthRoute(path: "change_request_status")
             
        case .getPolicy:
            return Router.oAuthRoute(path: "get_driver_page")
     
        case .say_thank_you:
            return Router.oAuthRoute(path: "say_thank_you")
        case .driver_vehicle_list:
            return Router.oAuthRoute(path: "driver_vehicle_list")
            
        case .delete_driver_vehicle:
            return Router.oAuthRoute(path: "delete_driver_vehicle")
            
        case .car_make:
            return Router.oAuthRoute(path: "car_make")
        case .car_model:
            return Router.oAuthRoute(path: "car_model")
        case .car_model_color:
            return Router.oAuthRoute(path: "car_model_color")
       
        case .driver_car_model_vehicle:
            return Router.oAuthRoute(path: "driver_car_model_vehicle")
        }
    }
    
    private static func oAuthRoute(path: String) -> String {
        return Router.BASE_SERVICE_URL + path
    }
}

