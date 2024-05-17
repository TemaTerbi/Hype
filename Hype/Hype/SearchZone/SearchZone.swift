//
//  SearchZone.swift
//  Hype
//
//  Created by Artem Solovev on 13.05.2024.
//

import SwiftUI

struct SearchZone: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var viewModelChatZone: ChatZoneViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.profilesList) { profile in
                ProfileCell(profile: profile)
            }
        }
        .padding(.top, 60)
        .onAppear {
            Task {
                await viewModel.fetchProfiles()
            }
        }
    }
}

#Preview {
    SearchZone()
}

struct ProfileCell: View {
    
    @State var profile: Profile
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.red)
                    .padding(10)
                    .overlay {
                        VStack {
                            Text("❤️")
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text(profile.username ?? "")
                        .font(.system(size: 23, weight: .medium, design: .rounded))
                }
                
                Spacer()
                
                Button("Начать общение") {
                    Task {
                        await SupabaseService.shared._dataBaseService.insertNewRoom(guestUserId: profile.id)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 76)
            .background(Color.white)
            
            Button("Выйти") {
                Task {
                    await SupabaseService.shared._authorizeService.signOut()
                }
            }
        }
    }
}
