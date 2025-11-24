//
//  DriverStatus.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 07/08/23.
//

import Foundation

struct ApiDriverStatus : Codable {
    
    let result : String?
    let available_status : String?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case available_status = "available_status"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        available_status = try values.decodeIfPresent(String.self, forKey: .available_status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
