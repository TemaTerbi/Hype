//
//  ChatZoneViewModel.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import Foundation

class ChatZoneViewModel: ObservableObject {
    
    @Published private var stateOfChatList: StateOfChatList = .emptyList
    
    func getStateOfChatList() -> StateOfChatList {
        return stateOfChatList
    }
    
    func changeStateOfChatList() {
        stateOfChatList = StateOfChatList.allCases.randomElement() ?? .emptyList
    }
}
