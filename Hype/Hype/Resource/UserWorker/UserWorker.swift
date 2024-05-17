//
//  UserWorker.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import Foundation
import Supabase


class UserWorker: UserWorkerProtocol {
    
    private var client: SupabaseClient?
    private var authorizeService: AuthorizeServiceProtocol?
    
    private var _client: SupabaseClient {
        if let client = self.client {
            return client
        }
        
        fatalError("Клиент не был инициализирован")
    }
    
    private var _authorizeService: AuthorizeServiceProtocol {
        if let authorizeService = self.authorizeService {
            return authorizeService
        }
        
        fatalError("Сервис авторизации не был инициализирован")
    }
    
    func buildWorker(client: SupabaseClient, authorizeService: AuthorizeServiceProtocol) {
        self.client = client
        self.authorizeService = authorizeService
    }
    
    func getCurrentUser() async {
        do {
            let profiles: [Profile] = try await _client.from(EnvObject.profilesTable)
                .select()
                .execute()
                .value
            
            let user = profiles.first { profile in
                profile.id == _authorizeService.getSession.user.id
            }
            
            print(user)
        } catch(let error) {
            _authorizeService.invalidSession()
            print(error)
        }
    }
    
    func getCurrentUserBy(id: UUID) async -> Profile {
        do {
            let profiles: [Profile] = try await _client.from(EnvObject.profilesTable)
                .select()
                .execute()
                .value
            
            let user = profiles.first { profile in
                profile.id == id
            }
            
            if let userNonOptional = user  {
                return userNonOptional
            }
        } catch(let error) {
            _authorizeService.invalidSession()
            print(error)
        }
        
        return Profile(id: UUID())
    }
}
