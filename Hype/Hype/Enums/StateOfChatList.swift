//
//  StateOfChatList.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

enum StateOfChatList: CaseIterable {
    case emptyList
    case someError
    case loadingChats
    case chatWasLoading
}
