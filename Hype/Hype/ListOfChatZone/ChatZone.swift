//
//  ChatZone.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatZone: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Header()
            
            ScrollView {
               
                VStack(spacing: 0) {
                    ChatCell()
                    ChatCell()
                }
                .cornerRadius(20)
                .padding(.top, 100)
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }
}

#Preview {
    ChatZone()
}
