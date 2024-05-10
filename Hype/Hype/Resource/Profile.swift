//
//  Profile.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Foundation

struct Profile: Decodable {
    var id: UUID
    var full_name: String
    var email: String
}
