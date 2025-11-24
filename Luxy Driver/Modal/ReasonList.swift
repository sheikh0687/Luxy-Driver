//
//  ReasonList.swift
//  Luxy Driver
//
//  Created by Techimmense Software Solutions on 12/12/24.
//

import Foundation

struct Api_CancelReason : Codable {
    let result : [Res_CancelReason]?
    let message : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case result = "result"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_CancelReason].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_CancelReason : Codable {
    let id : String?
    let reason : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case reason = "reason"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
