//
//  Complaint.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 08/08/23.
//

import Foundation

struct ApiFeedback : Codable {
    
    let result : ResFeedback?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(ResFeedback.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct ResFeedback : Codable {
    let id : String?
    let user_id : String?
    let email : String?
    let message : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case email = "email"
        case message = "message"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }
}
