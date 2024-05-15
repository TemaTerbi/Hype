//
//  MessageTetField.swift
//  Hype
//
//  Created by Artem Solovev on 16.05.2024.
//

import SwiftUI

struct MessageTetField: View {
    
    @Binding var messageText: String
    @FocusState var isTapped: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Text(messageText.isEmpty ? "Сообщение" : "")
                    .foregroundStyle(Color.gray)
                
                TextField("", text: $messageText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
        }
        .frame(width: 250, height: 44)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .ignoresSafeArea(.all, edges: .bottom)
        .focused($isTapped, equals: true)
    }
}
