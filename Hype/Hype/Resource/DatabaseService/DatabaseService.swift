//
//  DatabaseService.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import Foundation
import Supabase

class DatabaseService: DatabaseServiceProtocol {
    
    private var client: SupabaseClient?
    private var authorizeService: AuthorizeServiceProtocol?
    private var userWorker: UserWorkerProtocol?
    
    private var _client: SupabaseClient {
        if let client = self.client {
            return client
        }
        
        fatalError("client не был инициализирован")
    }
    
    private var _authorizeService: AuthorizeServiceProtocol {
        if let authorizeService = self.authorizeService {
            return authorizeService
        }
        
        fatalError("authorizeService не был инициализирован")
    }
    
    private var _userWorker: UserWorkerProtocol {
        if let userWorker = self.userWorker {
            return userWorker
        }
        
        fatalError("userWorker не был инициализирован")
    }
    
    func buildDatabaseService(client: SupabaseClient, authorizeService: AuthorizeServiceProtocol, userWorker: UserWorkerProtocol) {
        self.client = client
        self.authorizeService = authorizeService
        self.userWorker = userWorker
    }
    
    func fetchProfiles() async -> [Profile] {
        do {
            let profiles: [Profile] = try await _client.from(EnvObject.profilesTable)
                .select()
                .execute()
                .value
            
            let filterProfiles = profiles.filter { $0.id != _authorizeService.getSession.user.id }
            
            return filterProfiles
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func fetchRooms() async -> [Rooms] {
        var resultRoom: [Rooms] = []
        
        do {
            let myOwnRooms: [Rooms] = try await _authorizeService.getClient.from(EnvObject.roomsTable)
                .select()
                .eq("own_user", value: _authorizeService.getSession.user.id)
                .execute()
                .value
            
            let guestRoom: [Rooms] = try await _authorizeService.getClient.from(EnvObject.roomsTable)
                .select()
                .eq("guest_user", value: _authorizeService.getSession.user.id)
                .execute()
                .value
            
            let allRooms = myOwnRooms + guestRoom
            
            for room in allRooms {
                var currentRoom = room
                currentRoom.ownUserName = await _userWorker.getCurrentUserBy(id: currentRoom.own_user).username ?? ""
                currentRoom.guestUserName = await _userWorker.getCurrentUserBy(id: currentRoom.guest_user).username ?? ""
                
                resultRoom.append(currentRoom)
            }
            
            return resultRoom
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func insertNewRoom(guestUserId: UUID) async {
        let rooms = Rooms(own_user: _authorizeService.getSession.user.id, guest_user: guestUserId, messages: [], chanel_token: "\(Int.random(in: 0...10000))")
        
        do {
            let _ = try await _client.from(EnvObject.roomsTable)
                .insert(rooms)
                .execute()
        } catch (let error) {
            print(error)
        }
    }
}
