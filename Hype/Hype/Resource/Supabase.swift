//
//  Supabase.swift
//  Hype
//
//  Created by Artem Solovev on 10.05.2024.
//

import Foundation
import Supabase
import SwiftUI

class SupabaseService {
    static let shared = SupabaseService(authorizeService: AuthorizeService(), userWorker: UserWorker())
    
    private let client = SupabaseClient(supabaseURL: URL(string: EnvObject.supabaseUrl)!, supabaseKey: EnvObject.supabaseKey)
    private let authorizeService: AuthorizeServiceProtocol
    private let userWorker: UserWorkerProtocol
    
    var _authorizeService: AuthorizeServiceProtocol {
        return authorizeService
    }
    
    var _userWorker: UserWorkerProtocol {
        return userWorker
    }
    
    init(authorizeService: AuthorizeServiceProtocol, userWorker: UserWorkerProtocol) {
        self.authorizeService = authorizeService
        self.userWorker = userWorker
        authorizeService.buildAuthorizeService(client: client)
        userWorker.buildWorker(client: client, authorizeService: authorizeService)
    }
    
    func fetchProfiles() async -> [Profile] {
        do {
            let profiles: [Profile] = try await client.from(EnvObject.profilesTable)
                .select()
                .execute()
                .value
            
            let filterProfiles = profiles.filter { $0.id != authorizeService.getSession.user.id }
            
            return filterProfiles
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func fetchRooms() async -> [Rooms] {
        var resultRoom: [Rooms] = []
        
        do {
            let myOwnRooms: [Rooms] = try await authorizeService.getClient.from(EnvObject.roomsTable)
                .select()
                .eq("own_user", value: authorizeService.getSession.user.id)
                .execute()
                .value
            
            let guestRoom: [Rooms] = try await authorizeService.getClient.from(EnvObject.roomsTable)
                .select()
                .eq("guest_user", value: authorizeService.getSession.user.id)
                .execute()
                .value
            
            let allRooms = myOwnRooms + guestRoom
            
            for room in allRooms {
                var currentRoom = room
                currentRoom.ownUserName = await userWorker.getCurrentUserBy(id: currentRoom.own_user).username ?? ""
                currentRoom.guestUserName = await userWorker.getCurrentUserBy(id: currentRoom.guest_user).username ?? ""
                
                resultRoom.append(currentRoom)
            }
            
            return resultRoom
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func insertNewRoom(guestUserId: UUID) async {
        let rooms = Rooms(own_user: authorizeService.getSession.user.id ?? UUID(), guest_user: guestUserId, messages: [], chanel_token: "\(Int.random(in: 0...10000))")
        
        do {
            let response = try await client.from(EnvObject.roomsTable)
                .insert(rooms)
                .execute()
        } catch (let error) {
            print(error)
        }
    }
    
    func startListening(returnNewRoom: @escaping (Rooms) -> Void) async {
        let channel = await client.channel("changeRooms")
        
        let insertions = await channel.postgresChange(
            InsertAction.self,
            schema: "public",
            table: EnvObject.roomsTable
        )
        
        await channel.subscribe()
        
        for await insert in insertions {
            let dictionary = insert.record
            do {
                var newRoom = try dictionary.decode(as: Rooms.self, decoder: JSONDecoder())
                newRoom.ownUserName = await userWorker.getCurrentUserBy(id: newRoom.own_user).username ?? ""
                newRoom.guestUserName = await userWorker.getCurrentUserBy(id: newRoom.guest_user).username ?? ""
                returnNewRoom(newRoom)
            } catch(let error) {
                print(error)
            }
        }
    }
    
    func getSessionId() -> UUID {
        authorizeService.getSession.user.id
    }
}
