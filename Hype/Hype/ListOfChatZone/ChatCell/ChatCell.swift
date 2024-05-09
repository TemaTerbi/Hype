//
//  ChatCell.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ChatCell: View {
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
                Text("Долбаеб")
                    .font(.system(size: 23, weight: .medium, design: .rounded))
                
                Text("Дароу, пойдешь в валик сегодня?")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 76)
        .background(Color.white)
    }
}

#Preview {
    ChatCell()
}
