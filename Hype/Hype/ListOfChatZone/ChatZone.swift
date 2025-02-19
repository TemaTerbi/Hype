//
//  ChatZone.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatZone: View {
    
    @EnvironmentObject private var viewModel: ChatZoneViewModel
    @Binding var tabbarIsShow: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Header(stateOfChatList: $viewModel.stateOfChatList)
            
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
                ScrollView {
                   
                    VStack(spacing: 0) {
                        ForEach(viewModel.roomsList) { room in
                            NavigationLink {
                                MessagesWindow(tabbarIsShow: $tabbarIsShow)
                            } label: {
                                ChatCell(room: room)
                            }
                        }
                    }
                    .cornerRadius(20)
                    .padding(.top, 100)
                }
                .ignoresSafeArea(.all, edges: .top)
                .scrollIndicators(.hidden)
                .onAppear {
                    withAnimation(.bouncy) {
                        tabbarIsShow = true
                    }
                }
            }
        }
    }
}

//#Preview {
//    ChatZone()
//}
