//
//  Make.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 14/04/25.
//

import Foundation

struct Api_MakeCar : Codable {
    let result : [Res_MakeCar]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_MakeCar].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_MakeCar : Codable {
    let id : String?
    let make : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case make = "make"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        make = try values.decodeIfPresent(String.self, forKey: .make)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }
}
