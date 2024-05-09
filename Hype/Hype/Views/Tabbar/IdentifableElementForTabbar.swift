//
//  IdentifableElementForTabbar.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Foundation

struct IdentifableElementForTabbar: Identifiable, Equatable {
    var id = UUID()
    var textOfElement: String = "Чаты"
    var image: String = "chat"
    var indexOfElement: Int = 1
}
