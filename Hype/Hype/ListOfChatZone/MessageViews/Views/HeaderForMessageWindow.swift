//
//  HeaderForMessageWindow.swift
//  Hype
//
//  Created by Artem Solovev on 16.05.2024.
//

import SwiftUI

struct HeaderForMessageWindow: ToolbarContent {
    
    @Environment(\.presentationMode) private var presentationMode
    @FocusState var tappedOnMessageTextField: Bool
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            VStack {
                Image(ImagesName.backArrow.rawValue)
            }
            .frame(width: 44, height: 44)
            .background(Color.white)
            .cornerRadius(16)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
            .shadow(radius: 10)
        }
        
        ToolbarItem(placement: .principal) {
            HStack {
                Text("Name of guest")
                    .padding(12)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}
