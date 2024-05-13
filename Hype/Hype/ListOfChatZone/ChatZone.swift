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
                
                Button("Добавить комнату") {
                    Task {
                        await SupabaseService.shared.insertNewRoom()
                    }
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
                ScrollView {
                   
                    VStack(spacing: 0) {
                        ForEach(viewModel.roomsList) { room in
                            ChatCell(room: room)
                        }
                        
                        Button("Добавить комнату") {
                            Task {
                                await SupabaseService.shared.insertNewRoom()
                            }
                        }
                    }
                    .cornerRadius(20)
                    .padding(.top, 100)
                }
                .ignoresSafeArea(.all, edges: .top)
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    ChatZone()
}
