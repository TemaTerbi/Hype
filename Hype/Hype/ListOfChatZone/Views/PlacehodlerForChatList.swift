//
//  PlacehodlerForChatList.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct PlacehodlerForChatList: View {
    
    var descriptionString = "Начните искать друзей, чтобы начать вашу историю общения!"
    var imageNameFromResources: ImagesName = .emptyHome
    var showButton: Bool = true
    var textOfButton: String?
    
    var funcForButton: (() -> Void)?
    
    var body: some View {
        VStack {
            VStack {
                Image(imageNameFromResources.rawValue)
                
                Text(descriptionString)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 21, weight: .medium, design: .rounded))
                    .lineLimit(2)
                    .padding(.horizontal, 40)
                
                if showButton {
                    DefaultWhiteButton(textOfButton: textOfButton ?? "") {
                        funcForButton?()
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 150)
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.top, 55)
    }
}
