//
//  ContentViewModel.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Combine
import Foundation

class ContentViewModel: ObservableObject {
    @Published private var signinState: SigningState = .logout
    private var bag = Set<AnyCancellable>()
    
    init() {
        getSessionStateFromManager()
    }
    
    private func getSessionStateFromManager() {
        SupabaseService.shared._authorizeService.getSiginState.sink { state in
            DispatchQueue.main.async {
                self.signinState = state
            }
        }.store(in: &bag)
    }
    
    func getSessionState() -> SigningState {
        signinState
    }
}
