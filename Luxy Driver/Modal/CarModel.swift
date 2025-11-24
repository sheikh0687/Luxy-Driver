//
//  CarModel.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import Foundation

struct Api_CarModel : Codable {
    let result : [Res_CarModel]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_CarModel].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_CarModel : Codable {
    let id : String?
    let make_id : String?
    let vehicle_id : String?
    let make : String?
    let model : String?
    let year_below_5_year : String?
    let year_older_then_5_year : String?
    let max_limit_older_car : String?
    let date_time : String?
    let year_list : [Year_list]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case make_id = "make_id"
        case vehicle_id = "vehicle_id"
        case make = "make"
        case model = "model"
        case year_below_5_year = "year_below_5_year"
        case year_older_then_5_year = "year_older_then_5_year"
        case max_limit_older_car = "max_limit_older_car"
        case date_time = "date_time"
        case year_list = "year_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        make_id = try values.decodeIfPresent(String.self, forKey: .make_id)
        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
        make = try values.decodeIfPresent(String.self, forKey: .make)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        year_below_5_year = try values.decodeIfPresent(String.self, forKey: .year_below_5_year)
        year_older_then_5_year = try values.decodeIfPresent(String.self, forKey: .year_older_then_5_year)
        max_limit_older_car = try values.decodeIfPresent(String.self, forKey: .max_limit_older_car)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        year_list = try values.decodeIfPresent([Year_list].self, forKey: .year_list)
    }

}

struct Year_list : Codable {
    let id : String?
    let year : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case year = "year"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
