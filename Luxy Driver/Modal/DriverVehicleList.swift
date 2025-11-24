//
//  DriverVehicleList.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import Foundation

struct Api_DriverVehicleList : Codable {
    
    let result : [Res_DriverVehicleList]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_DriverVehicleList].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_DriverVehicleList : Codable {
    let id : String?
    let driver_id : String?
    let vehicle_id : String?
    let vehicle_name : String?
    let vehicle_work_type : String?
    let make_id : String?
    let make_name : String?
    let model_id : String?
    let model_name : String?
    let year : String?
    let color_id : String?
    let color_name : String?
    let color_image : String?
    let license_plate_number : String?
    let vehicle_registration_image : String?
    let vehicle_insurance_image : String?
    let vehicle_front_image : String?
    let vehicle_back_image : String?
    let vehicle_left_side_image : String?
    let vehicle_right_side_image : String?
    let commercial_type : String?
    let vehicle_registration_number : String?
    let status : String?
    let remove_status : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case driver_id = "driver_id"
        case vehicle_id = "vehicle_id"
        case vehicle_name = "vehicle_name"
        case vehicle_work_type = "vehicle_work_type"
        case make_id = "make_id"
        case make_name = "make_name"
        case model_id = "model_id"
        case model_name = "model_name"
        case year = "year"
        case color_id = "color_id"
        case color_name = "color_name"
        case color_image = "color_image"
        case license_plate_number = "license_plate_number"
        case vehicle_registration_image = "vehicle_registration_image"
        case vehicle_insurance_image = "vehicle_insurance_image"
        case vehicle_front_image = "vehicle_front_image"
        case vehicle_back_image = "vehicle_back_image"
        case vehicle_left_side_image = "vehicle_left_side_image"
        case vehicle_right_side_image = "vehicle_right_side_image"
        case commercial_type = "commercial_type"
        case vehicle_registration_number = "vehicle_registration_number"
        case status = "status"
        case remove_status = "remove_status"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        driver_id = try values.decodeIfPresent(String.self, forKey: .driver_id)
        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
        vehicle_name = try values.decodeIfPresent(String.self, forKey: .vehicle_name)
        vehicle_work_type = try values.decodeIfPresent(String.self, forKey: .vehicle_work_type)
        make_id = try values.decodeIfPresent(String.self, forKey: .make_id)
        make_name = try values.decodeIfPresent(String.self, forKey: .make_name)
        model_id = try values.decodeIfPresent(String.self, forKey: .model_id)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        color_id = try values.decodeIfPresent(String.self, forKey: .color_id)
        color_name = try values.decodeIfPresent(String.self, forKey: .color_name)
        color_image = try values.decodeIfPresent(String.self, forKey: .color_image)
        license_plate_number = try values.decodeIfPresent(String.self, forKey: .license_plate_number)
        vehicle_registration_image = try values.decodeIfPresent(String.self, forKey: .vehicle_registration_image)
        vehicle_insurance_image = try values.decodeIfPresent(String.self, forKey: .vehicle_insurance_image)
        vehicle_front_image = try values.decodeIfPresent(String.self, forKey: .vehicle_front_image)
        vehicle_back_image = try values.decodeIfPresent(String.self, forKey: .vehicle_back_image)
        vehicle_left_side_image = try values.decodeIfPresent(String.self, forKey: .vehicle_left_side_image)
        vehicle_right_side_image = try values.decodeIfPresent(String.self, forKey: .vehicle_right_side_image)
        commercial_type = try values.decodeIfPresent(String.self, forKey: .commercial_type)
        vehicle_registration_number = try values.decodeIfPresent(String.self, forKey: .vehicle_registration_number)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        remove_status = try values.decodeIfPresent(String.self, forKey: .remove_status)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
