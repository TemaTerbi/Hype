//
//  Profile.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Foundation
import PostgREST

struct Profile: Codable {
    var id: UUID
    var full_name: String?
    var email: String?
    var username: String?
}

struct Rooms: Codable, Sendable, Identifiable {
    var id: Int?
    var own_user: UUID
    var guest_user: UUID
    var messages: [[String: AnyJSON]]?
    var chanel_token: String?
    
    var ownUserName: String?
    var guestUserName: String?
}
