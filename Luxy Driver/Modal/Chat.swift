//
//  Chat.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 12/08/23.
//

import Foundation

struct ApiChat : Codable {
    
    let result : [ResChat]?
    let status : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([ResChat].self, forKey: .result)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct ResChat : Codable {
    let id : String?
    let vehicle_id : String?
    let vehicle_name : String?
    let first_name : String?
    let last_name : String?
    let username : String?
    let mobile : String?
    let mobile_witth_country_code : String?
    let email : String?
    let password : String?
    let country_id : String?
    let country : String?
    let state_id : String?
    let city_id : String?
    let image : String?
    let type : String?
    let social_id : String?
    let lat : String?
    let lon : String?
    let address : String?
    let gender : String?
    let wallet : String?
    let registration_no : String?
    let licence_image : String?
    let vehicle_image : String?
    let admin_vehicle_image : String?
    let vehicle_insura_image : String?
    let vehicle_work_type : String?
    let registration_image : String?
    let register_id : String?
    let ios_register_id : String?
    let status : String?
    let available_status : String?
    let code : String?
    let date_time : String?
    let plan_id : String?
    let exp_date : String?
    let total_deliveries : String?
    let expiry_month : String?
    let expiry_year : String?
    let card_number : String?
    let card_holder_name : String?
    let no_of_message : Int?
    let last_message : String?
    let request_id : String?
    let request_name : String?
    let date : String?
    let sender_id : String?
    let receiver_id : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case vehicle_id = "vehicle_id"
        case vehicle_name = "vehicle_name"
        case first_name = "first_name"
        case last_name = "last_name"
        case username = "username"
        case mobile = "mobile"
        case mobile_witth_country_code = "mobile_witth_country_code"
        case email = "email"
        case password = "password"
        case country_id = "country_id"
        case country = "country"
        case state_id = "state_id"
        case city_id = "city_id"
        case image = "image"
        case type = "type"
        case social_id = "social_id"
        case lat = "lat"
        case lon = "lon"
        case address = "address"
        case gender = "gender"
        case wallet = "wallet"
        case registration_no = "registration_no"
        case licence_image = "licence_image"
        case vehicle_image = "vehicle_image"
        case admin_vehicle_image = "admin_vehicle_image"
        case vehicle_insura_image = "vehicle_insura_image"
        case vehicle_work_type = "vehicle_work_type"
        case registration_image = "registration_image"
        case register_id = "register_id"
        case ios_register_id = "ios_register_id"
        case status = "status"
        case available_status = "available_status"
        case code = "code"
        case date_time = "date_time"
        case plan_id = "plan_id"
        case exp_date = "exp_date"
        case total_deliveries = "total_deliveries"
        case expiry_month = "expiry_month"
        case expiry_year = "expiry_year"
        case card_number = "card_number"
        case card_holder_name = "card_holder_name"
        case no_of_message = "no_of_message"
        case last_message = "last_message"
        case request_id = "request_id"
        case request_name = "request_name"
        case date = "date"
        case sender_id = "sender_id"
        case receiver_id = "receiver_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
        vehicle_name = try values.decodeIfPresent(String.self, forKey: .vehicle_name)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        mobile_witth_country_code = try values.decodeIfPresent(String.self, forKey: .mobile_witth_country_code)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        city_id = try values.decodeIfPresent(String.self, forKey: .city_id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        social_id = try values.decodeIfPresent(String.self, forKey: .social_id)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        wallet = try values.decodeIfPresent(String.self, forKey: .wallet)
        registration_no = try values.decodeIfPresent(String.self, forKey: .registration_no)
        licence_image = try values.decodeIfPresent(String.self, forKey: .licence_image)
        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
        admin_vehicle_image = try values.decodeIfPresent(String.self, forKey: .admin_vehicle_image)
        vehicle_insura_image = try values.decodeIfPresent(String.self, forKey: .vehicle_insura_image)
        vehicle_work_type = try values.decodeIfPresent(String.self, forKey: .vehicle_work_type)
        registration_image = try values.decodeIfPresent(String.self, forKey: .registration_image)
        register_id = try values.decodeIfPresent(String.self, forKey: .register_id)
        ios_register_id = try values.decodeIfPresent(String.self, forKey: .ios_register_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        available_status = try values.decodeIfPresent(String.self, forKey: .available_status)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        plan_id = try values.decodeIfPresent(String.self, forKey: .plan_id)
        exp_date = try values.decodeIfPresent(String.self, forKey: .exp_date)
        total_deliveries = try values.decodeIfPresent(String.self, forKey: .total_deliveries)
        expiry_month = try values.decodeIfPresent(String.self, forKey: .expiry_month)
        expiry_year = try values.decodeIfPresent(String.self, forKey: .expiry_year)
        card_number = try values.decodeIfPresent(String.self, forKey: .card_number)
        card_holder_name = try values.decodeIfPresent(String.self, forKey: .card_holder_name)
        no_of_message = try values.decodeIfPresent(Int.self, forKey: .no_of_message)
        last_message = try values.decodeIfPresent(String.self, forKey: .last_message)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        request_name = try values.decodeIfPresent(String.self, forKey: .request_name)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        sender_id = try values.decodeIfPresent(String.self, forKey: .sender_id)
        receiver_id = try values.decodeIfPresent(String.self, forKey: .receiver_id)
    }
}

