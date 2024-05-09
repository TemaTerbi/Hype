//
//  HeaderOfChatList.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct Header: View {
    var body: some View {
        GeometryReader { gr -> AnyView in
            return AnyView(
                HStack() {
                    
                    Spacer()
                    
                    Text("Твои чаты")
                        .font(.system(size: 26, weight: .medium, design: .rounded))
                        .padding(.top, 60)
                        .offset(y: -gr.frame(in: .global).minY)
                    
                    Spacer()
                }
                    .background(Color.pinkLight)
            )
        }
    }
}
