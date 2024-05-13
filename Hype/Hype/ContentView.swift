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
                            await SupabaseService.shared.sigIn(email: "tematerbiapple@mail.ru", password: "123456")
                        }
                    }
                    
                    Button("Войти TeRb1") {
                        Task {
                            await SupabaseService.shared.sigIn(email: "tematerbi@mail.ru", password: "123456")
                        }
                    }
                    
                    Button("Рега") {
                        Task {
                            await SupabaseService.shared.signUp(email: "tematerbiapple@mail.ru", password: "123456")
                        }
                    }
                }
            case .loggin:
                Tabbar()
                    .onAppear {
                        Task {
                            await SupabaseService.shared.getCurrentUser()
                        }
                    }
            }
        }
        .onAppear {
            Task {
                await SupabaseService.shared.checkSession()
            }
        }
    }
}

#Preview {
    ContentView()
}
