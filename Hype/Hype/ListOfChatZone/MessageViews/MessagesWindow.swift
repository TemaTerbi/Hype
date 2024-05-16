//
//  MessagesWindow.swift
//  Hype
//
//  Created by Artem Solovev on 13.05.2024.
//

import SwiftUI

struct MessagesWindow: View {
    
    @State private var messageText: String = ""
    @FocusState private var tappedOnMessageTextField: Bool
    @Binding var tabbarIsShow: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(0..<20) { i in
                            HStack {
                                Spacer()
                                
                                MessageView()
                            }
                            .id(i)
                        }
                    }
                    .ignoresSafeArea(.all, edges: .top)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        value.scrollTo(19, anchor: .bottom)
                    }
                }
            }
            .padding(.horizontal, 10)
            
        }
        .background(content: {
            Image(ImagesName.chatBackground.rawValue)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
        })
        .safeAreaInset(edge: .top, content: {
            HeaderForMessageWindow(tappedOnMessageTextField: _tappedOnMessageTextField)
        })
        .safeAreaInset(edge: .bottom, content: {
            MessageControlView(tappedOnMessageTextField: _tappedOnMessageTextField, messageText: $messageText)
        })
        .navigationBarBackButtonHidden()
        .onAppear {
            withAnimation(.bouncy) {
                tabbarIsShow = false
            }
        }
    }
}

#Preview {
    MessagesWindow(tabbarIsShow: .constant(false))
}
