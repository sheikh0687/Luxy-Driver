//
//  CancelRequest.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 07/08/23.
//

import Foundation

struct ApiCancelRequest : Codable {
    
    let result : ResCancelRequest?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(ResCancelRequest.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct ResCancelRequest : Codable {
    let id : String?
    let request_id : String?
    let driver_id : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case request_id = "request_id"
        case driver_id = "driver_id"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        driver_id = try values.decodeIfPresent(String.self, forKey: .driver_id)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }
}
