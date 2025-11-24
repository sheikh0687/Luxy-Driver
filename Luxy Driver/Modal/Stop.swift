//
//  Stop.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 09/02/24.
//

import Foundation

struct ApiConfirmStop : Codable {
    let result : ResConfirmStop?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(ResConfirmStop.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct ResConfirmStop : Codable {
    let id : String?
    let user_id : String?
    let request_id : String?
    let start_address : String?
    let start_lat : String?
    let start_lon : String?
    let stop_address : String?
    let stop_lat : String?
    let stop_lon : String?
    let distance : String?
    let total_amount : String?
    let admin_commission : String?
    let driver_amount : String?
    let start_waiting_time : String?
    let end_waiting_time : String?
    let total_waiting_time : String?
    let total_waiting_amount : String?
    let status : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case request_id = "request_id"
        case start_address = "start_address"
        case start_lat = "start_lat"
        case start_lon = "start_lon"
        case stop_address = "stop_address"
        case stop_lat = "stop_lat"
        case stop_lon = "stop_lon"
        case distance = "distance"
        case total_amount = "total_amount"
        case admin_commission = "admin_commission"
        case driver_amount = "driver_amount"
        case start_waiting_time = "start_waiting_time"
        case end_waiting_time = "end_waiting_time"
        case total_waiting_time = "total_waiting_time"
        case total_waiting_amount = "total_waiting_amount"
        case status = "status"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        start_address = try values.decodeIfPresent(String.self, forKey: .start_address)
        start_lat = try values.decodeIfPresent(String.self, forKey: .start_lat)
        start_lon = try values.decodeIfPresent(String.self, forKey: .start_lon)
        stop_address = try values.decodeIfPresent(String.self, forKey: .stop_address)
        stop_lat = try values.decodeIfPresent(String.self, forKey: .stop_lat)
        stop_lon = try values.decodeIfPresent(String.self, forKey: .stop_lon)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        admin_commission = try values.decodeIfPresent(String.self, forKey: .admin_commission)
        driver_amount = try values.decodeIfPresent(String.self, forKey: .driver_amount)
        start_waiting_time = try values.decodeIfPresent(String.self, forKey: .start_waiting_time)
        end_waiting_time = try values.decodeIfPresent(String.self, forKey: .end_waiting_time)
        total_waiting_time = try values.decodeIfPresent(String.self, forKey: .total_waiting_time)
        total_waiting_amount = try values.decodeIfPresent(String.self, forKey: .total_waiting_amount)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }
}
