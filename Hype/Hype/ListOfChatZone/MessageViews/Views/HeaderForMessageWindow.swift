//
//  HeaderForMessageWindow.swift
//  Hype
//
//  Created by Artem Solovev on 16.05.2024.
//

import SwiftUI

struct HeaderForMessageWindow: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @FocusState var tappedOnMessageTextField: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(ImagesName.backArrow.rawValue)
                }
                .frame(width: 44, height: 44)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.trailing, 53)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                .shadow(radius: 10)
                
                HStack {
                    Text("Name of guest")
                        .padding(12)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 76)
            .padding(.top, 80)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .ignoresSafeArea(.all, edges: .top)
        .offset(CGSize(width: 0, height: tappedOnMessageTextField ? 150 : 0))
    }
}
