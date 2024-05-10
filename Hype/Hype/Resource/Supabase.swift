//
//  Supabase.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Foundation
import Supabase
import SwiftUI

class SupabaseManager {
    private let client = SupabaseClient(supabaseURL: URL(string: EnvObject.supabaseUrl)!, supabaseKey: EnvObject.supabaseKey)
    private var session: Session?
    
    static let shared = SupabaseManager()
    
    @Published var sigInState: SigningState = .logout
    
    //MARK: - Private func
    private func checkUserForSigin() async {
        do {
            session = try await client.auth.session
            sigInState = .loggin
        } catch {
            invalidSession()
        }
    }
    
    private func invalidSession() {
        sigInState = .logout
        session = nil
        print("не удалось получить сессию")
    }
    
    //MARK: - Public func
    func sigIn(email: String, password: String) async {
        do {
            try await client.auth.signIn(email: email, password: password)
            
            await checkUserForSigin()
        } catch {
            print("Не удалось войти")
        }
    }
    
    func signOut() async {
        do {
            try await client.auth.signOut()
            await checkSession()
        } catch {
            print("Чет не выходит")
        }
    }
    
    func checkSession() async {
        do {
            session = try await client.auth.session
            sigInState = .loggin
        } catch {
            invalidSession()
            do {
                session = try await client.auth.refreshSession()
                sigInState = .loggin
            } catch {
                invalidSession()
            }
        }
    }
    
    func getSessionsState() -> SigningState {
        sigInState
    }
    
    func getCurrentUser() async {
        do {
            let profiles: [Profile] = try await client.from(EnvObject.profilesTable)
              .select()
              .execute()
              .value
            
            let user = profiles.first { profile in
                profile.id == session?.user.id
            }
            
            print(user)
        } catch {
            invalidSession()
            print("не удалось получить данные пользователя")
        }
    }
}
