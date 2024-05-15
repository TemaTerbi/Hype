//
//  MessageControlView.swift
//  Hype
//
//  Created by Artem Solovev on 16.05.2024.
//

import SwiftUI

struct MessageControlView: View {
    
    @FocusState var tappedOnMessageTextField: Bool
    @Binding var messageText: String
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                MessageTetField(messageText: $messageText, isTapped: _tappedOnMessageTextField)
            }
            .frame(maxWidth: .infinity, maxHeight: 76)
            .background(.ultraThinMaterial)
            .background(Color.purpleSolid)
            .padding(.bottom, 75)
        }
        .offset(CGSize(width: 0, height: tappedOnMessageTextField ? -170 : 10))
    }
}
