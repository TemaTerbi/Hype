//
//  HeaderOfChatList.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct Header: View {
    
    @Binding var stateOfChatList: StateOfChatList
    
    var body: some View {
        GeometryReader { gr -> AnyView in
            return AnyView(
                HStack {
                    
                    Spacer()
                    
                    switch stateOfChatList {
                    case .emptyList:
                        Text("Начните общение!")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .padding(.top, 60)
                            .offset(y: -gr.frame(in: .global).minY)
                    case .someError:
                        Text("Ля, ошибку словил...")
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .padding(.top, 60)
                            .offset(y: -gr.frame(in: .global).minY)
                    case .loadingChats:
                        Image(ImagesName.loadingIcon.rawValue)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.top, 60)
                            .offset(y: -gr.frame(in: .global).minY)
                        
                        Text("Галя, у нас загрузка!")
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .padding(.top, 60)
                            .offset(y: -gr.frame(in: .global).minY)
                    case .chatWasLoading:
                        Text("Твои чаты")
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .padding(.top, 60)
                            .offset(y: -gr.frame(in: .global).minY)
                    }
                    
                    Spacer()
                }
                    .background(Color.pinkLight)
            )
        }
    }
}
