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
        NavigationView {
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
            .safeAreaInset(edge: .bottom, content: {
                MessageControlView(tappedOnMessageTextField: _tappedOnMessageTextField, messageText: $messageText)
            })
            .onAppear {
                withAnimation(.bouncy) {
                    tabbarIsShow = false
                }
            }
        }
        .toolbar(content: {
            HeaderForMessageWindow(tappedOnMessageTextField: _tappedOnMessageTextField)
        })
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MessagesWindow(tabbarIsShow: .constant(false))
}
