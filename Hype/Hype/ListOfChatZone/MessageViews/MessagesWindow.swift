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
        ZStack {
            Image(ImagesName.chatBackground.rawValue)
            
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
                    .padding(.top, 80)
                    .padding(.bottom, tappedOnMessageTextField ? 340 : 150)
                    .ignoresSafeArea(.all, edges: .top)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        value.scrollTo(19, anchor: .top)
                    }
                    .onChange(of: tappedOnMessageTextField) { oldValue, newValue in
                        value.scrollTo(19, anchor: .top)
                    }
                }
            }
            .padding(.horizontal, 30)
            
            MessageControlView(tappedOnMessageTextField: _tappedOnMessageTextField, messageText: $messageText)
            
            HeaderForMessageWindow(tappedOnMessageTextField: _tappedOnMessageTextField)
        }
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
