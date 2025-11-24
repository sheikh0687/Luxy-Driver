//
//  CarColor.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import Foundation

struct Api_CarColorResource : Codable {
    let result : [Res_CarColorResource]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_CarColorResource].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

struct Res_CarColorResource : Codable {
    let id : String?
    let car_model_id : String?
    let color : String?
    let image : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case car_model_id = "car_model_id"
        case color = "color"
        case image = "image"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        car_model_id = try values.decodeIfPresent(String.self, forKey: .car_model_id)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
