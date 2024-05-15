//
//  MessageView.swift
//  Hype
//
//  Created by Artem Solovev on 13.05.2024.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        HStack {
            Text("Some message Some message Some message Some message Some message")
                .font(.system(size: 21, weight: .regular, design: .rounded))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
        }
//        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    MessageView()
}
