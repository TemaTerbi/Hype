//
//  ChatZone.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatZone: View {
    
    @StateObject private var viewModel = ChatZoneViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Header()
            
            switch viewModel.getStateOfChatList() {
            case .emptyList:
                PlacehodlerForChatList(textOfButton: "Найти...") {
                    viewModel.changeStateOfChatList()
                }
            case .someError:
                PlacehodlerForChatList(descriptionString: "Ой, какая-то ошибка...", imageNameFromResources: .someError, textOfButton: "Повторить") {
                    viewModel.changeStateOfChatList()
                }
            case .loadingChats:
                PlacehodlerForChatList(descriptionString: "Ща загружу, погоди", imageNameFromResources: .loadingIcon, showButton: false) {
                    viewModel.changeStateOfChatList()
                }
            case .chatWasLoading:
                ChatList()
                
                Button("Сменить состояние экрана") {
                    viewModel.changeStateOfChatList()
                }
            }
        }
    }
}

#Preview {
    ChatZone()
}
