//
//  AuthorizeService.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import SwiftUI
import Supabase

class AuthorizeService: AuthorizeServiceProtocol {
    
    private var client: SupabaseClient?
    private var session: Session?
    
    @Published private var sigInState: SigningState = .logout
    
    var getSiginState: Published<SigningState>.Publisher  {
        return $sigInState
    }
    
    var getSession: Session {
        if let session = session {
            return session
        }
        
        fatalError("Сессия не была инициализирована!")
    }
    
    var getClient: SupabaseClient {
        if let client = client {
            return client
        }
        
        fatalError("Клиент не был инициализирован!")
    }
    
    func buildAuthorizeService(client: SupabaseClient) {
        self.client = client
    }
    
    func checkUserForSigin() async {
        do {
            session = try await getClient.auth.session
            sigInState = .loggin
        } catch {
            invalidSession()
        }
    }
    
    func invalidSession() {
        sigInState = .logout
        session = nil
        print("не удалось получить сессию")
    }
    
    func sigIn(email: String, password: String) async {
        do {
            try await getClient.auth.signIn(email: email, password: password)
            
            await checkUserForSigin()
        } catch {
            print("Не удалось войти")
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            try await getClient.auth.signUp(email: email, password: password)
        } catch {
            //
        }
    }
    
    func signOut() async {
        do {
            try await getClient.auth.signOut()
            await checkSession()
        } catch {
            print("Чет не выходит")
        }
    }
    
    func checkSession() async {
        do {
            session = try await getClient.auth.session
            sigInState = .loggin
        } catch {
            invalidSession()
            do {
                session = try await getClient.auth.refreshSession()
                sigInState = .loggin
            } catch {
                invalidSession()
            }
        }
    }
    
    func getSessionsState() -> SigningState {
        sigInState
    }
}
