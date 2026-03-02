//
//  APNSModel.swift
//  SwiftUIBase
//
//  Created by hb on 02/03/26.
//

import Foundation

// MARK: - Notification Payload Model
struct PushNotificationPayload: Codable {
    let aps: APSPayload?
    let type: String?
    let targetID: String?
    
    enum CodingKeys: String, CodingKey {
        case aps
        case type
        case targetID = "target_id"
    }
}

struct APSPayload: Codable {
    let alert: APSAlert?
    let badge: Int?
    let sound: String?
}

struct APSAlert: Codable {
    let title: String?
    let body: String?
    let subtitle: String?
}

// MARK: - Notification Type
enum NotificationType: String, Codable {
    case home = "home"
    case redeem = "redeem"
    case wallet = "wallet"
    case profile = "profile"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = NotificationType(rawValue: value) ?? .unknown
    }
}

