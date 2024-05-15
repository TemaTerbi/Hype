//
//  SearchViewModel.swift
//  Hype
//
//  Created by Artem Solovev on 13.05.2024.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var profilesList: [Profile] = []
    
    func fetchProfiles() async {
        let profiles = await SupabaseService.shared.fetchProfiles()
        
        DispatchQueue.main.async {
            self.profilesList = profiles
        }
    }
}
