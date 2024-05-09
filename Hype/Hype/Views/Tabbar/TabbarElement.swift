//
//  TabbarElement.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import SwiftUI

struct TabbarElement: View {
    
    var data: IdentifableElementForTabbar
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            if tabSelection == data.indexOfElement {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.blue25, radius: 10)
                    .overlay {
                        Image(tabSelection == data.indexOfElement ? data.image + "Selected" : data.image + "Unselected")
                    }
            } else {
                Circle()
                    .fill(.clear)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(tabSelection == data.indexOfElement ? data.image + "Selected" : data.image + "Unselected")
                    }
            }
            
            Text(data.textOfElement)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(tabSelection == data.indexOfElement ? Color.black : Color.black60)
        }
        .padding(.bottom, 24)
    }
}
