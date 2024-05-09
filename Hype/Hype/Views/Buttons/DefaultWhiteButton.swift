//
//  DefaultWhiteButton.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import SwiftUI

struct DefaultWhiteButton: View {
    
    var textOfButton = "Найти..."
    var funcOfButton: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(textOfButton)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.blue25.opacity(0.65), radius: 10)
        .padding(.top, 20)
        .onTapGesture {
            funcOfButton?()
        }
    }
}
