//
//  ChatList.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatList: View {
    var body: some View {
        ScrollView {
           
            VStack(spacing: 0) {
                ChatCell()
                ChatCell()
                ChatCell()
                ChatCell()
            }
            .cornerRadius(20)
            .padding(.top, 100)
        }
        .ignoresSafeArea(.all, edges: .top)
        .scrollIndicators(.hidden)
    }
}
