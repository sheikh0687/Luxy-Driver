//
//  UpdateLocation.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/12/24.
//

import Foundation

struct Api_UpdateLocation : Codable {
    let distance_away : String?
    let time_away : String?
    let result : String?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case distance_away = "distance_away"
        case time_away = "time_away"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance_away = try values.decodeIfPresent(String.self, forKey: .distance_away)
        time_away = try values.decodeIfPresent(String.self, forKey: .time_away)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}
