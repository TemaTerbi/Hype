//
//  ContentView.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.getSessionState() {
            case .logout:
                VStack {
                    Button("Войти Imya") {
                        Task {
                            await SupabaseService.shared._authorizeService.sigIn(email: "tematerbiapple@mail.ru", password: "123456")
                        }
                    }
                    
                    Button("Войти TeRb1") {
                        Task {
                            await SupabaseService.shared._authorizeService.sigIn(email: "tematerbi@mail.ru", password: "123456")
                        }
                    }
                    
                    Button("Рега") {
                        Task {
                            await SupabaseService.shared._authorizeService.signUp(email: "tematerbiapple@mail.ru", password: "123456")
                        }
                    }
                }
            case .loggin:
                Tabbar()
                    .onAppear {
                        Task {
                            await SupabaseService.shared._userWorker.getCurrentUser()
                        }
                    }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            Task {
                await SupabaseService.shared._authorizeService.checkSession()
            }
        }
    }
}

#Preview {
    ContentView()
}
