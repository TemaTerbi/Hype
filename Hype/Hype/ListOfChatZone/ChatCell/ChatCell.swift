//
//  ChatCell.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatCell: View {
    
    @State private var lastetMessageFromUsername: String = ""
    @State private var lastetMessage: String = ""
    @State var room: Rooms
    
    private func setupData() {
        let messages = room.messages
        
        let keys = messages?.last?.keys.reversed()
        let lastKeyForMessage = keys?.first ?? ""
        
        lastetMessage = messages?.last?[lastKeyForMessage]?.stringValue ?? "Начните общаться с \(room.guestUserName ?? "")"
        
        lastetMessageFromUsername = room.guestUserName ?? ""
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.pinkLight)
                .padding(10)
                .overlay {
                    VStack {
                        Text("❤️")
                    }
                }
            
            VStack(alignment: .leading) {
                Text(lastetMessageFromUsername)
                    .font(.system(size: 23, weight: .medium, design: .rounded))
                
                Text(lastetMessage)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 76)
        .background(Color.white)
        .onAppear {
            setupData()
        }
    }
}
