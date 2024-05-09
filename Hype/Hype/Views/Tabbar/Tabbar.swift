//
//  Tabbar.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import SwiftUI

struct Tabbar: View {
    
    private var tabbarElements: [IdentifableElementForTabbar] = [
        IdentifableElementForTabbar(textOfElement: "Чаты", image: "chat", indexOfElement: 1),
        IdentifableElementForTabbar(textOfElement: "Поиск", image: "search", indexOfElement: 2),
    ]
    
    @State private var tabSelection = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                ChatZone()
                    .tag(1)
                
                Text("Тут будет поиск")
                    .tag(2)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    ForEach(tabbarElements) { el in
                        Spacer()
                        TabbarElement(data: el, tabSelection: $tabSelection)
                            .onTapGesture {
                                tabSelection = (tabbarElements.firstIndex(where: {$0 == el}) ?? 0) + 1
                            }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 106)
                .background(Color.purpleSolid)
                .clipShape(.rect(
                    topLeadingRadius: 20,
                    topTrailingRadius: 20
                ))
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

#Preview {
    Tabbar()
}
