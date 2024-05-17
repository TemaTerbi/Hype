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
    static let shared = SupabaseService(authorizeService: AuthorizeService(), userWorker: UserWorker(), dataBaseService: DatabaseService())
    
    private let client = SupabaseClient(supabaseURL: URL(string: EnvObject.supabaseUrl)!, supabaseKey: EnvObject.supabaseKey)
    
    private let authorizeService: AuthorizeServiceProtocol
    private let userWorker: UserWorkerProtocol
    private let dataBaseService: DatabaseServiceProtocol
    
    var _authorizeService: AuthorizeServiceProtocol {
        return authorizeService
    }
    
    var _userWorker: UserWorkerProtocol {
        return userWorker
    }
    
    var _dataBaseService: DatabaseServiceProtocol {
        return dataBaseService
    }
    
    init(authorizeService: AuthorizeServiceProtocol, userWorker: UserWorkerProtocol, dataBaseService: DatabaseServiceProtocol) {
        self.authorizeService = authorizeService
        self.userWorker = userWorker
        self.dataBaseService = dataBaseService
        authorizeService.buildAuthorizeService(client: client)
        userWorker.buildWorker(client: client, authorizeService: authorizeService)
        dataBaseService.buildDatabaseService(client: client, authorizeService: authorizeService, userWorker: userWorker)
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
