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
    private let client = SupabaseClient(supabaseURL: URL(string: EnvObject.supabaseUrl)!, supabaseKey: EnvObject.supabaseKey)
    private var session: Session?
    
    static let shared = SupabaseService()
    
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
    
    private func getCurrentUserBy(id: UUID) async -> Profile {
        do {
            let profiles: [Profile] = try await client.from(EnvObject.profilesTable)
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
            invalidSession()
            print(error)
        }
        
        return Profile(id: UUID())
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
    
    func signUp(email: String, password: String) async {
        do {
            try await client.auth.signUp(email: email, password: password)
        } catch {
            //
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
        } catch(let error) {
            invalidSession()
            print(error)
        }
    }
    
    func fetchProfiles() async -> [Profile] {
        do {
            let profiles: [Profile] = try await client.from(EnvObject.profilesTable)
                .select()
                .execute()
                .value
            
            let filterProfiles = profiles.filter { $0.id != session?.user.id }
            
            return filterProfiles
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func fetchRooms() async -> [Rooms] {
        var resultRoom: [Rooms] = []
        
        do {
            let myOwnRooms: [Rooms] = try await client.from(EnvObject.roomsTable)
                .select()
                .eq("own_user", value: session?.user.id)
                .execute()
                .value
            
            let guestRoom: [Rooms] = try await client.from(EnvObject.roomsTable)
                .select()
                .eq("guest_user", value: session?.user.id)
                .execute()
                .value
            
            let allRooms = myOwnRooms + guestRoom
            
            for room in allRooms {
                var currentRoom = room
                currentRoom.ownUserName = await getCurrentUserBy(id: currentRoom.own_user).username ?? ""
                currentRoom.guestUserName = await getCurrentUserBy(id: currentRoom.guest_user).username ?? ""
                
                resultRoom.append(currentRoom)
            }
            
            return resultRoom
        } catch(let error) {
            print(error)
            return []
        }
    }
    
    func insertNewRoom(guestUserId: UUID) async {
        let rooms = Rooms(own_user: session?.user.id ?? UUID(), guest_user: guestUserId, messages: [], chanel_token: "\(Int.random(in: 0...10000))")
        
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
                newRoom.ownUserName = await getCurrentUserBy(id: newRoom.own_user).username ?? ""
                newRoom.guestUserName = await getCurrentUserBy(id: newRoom.guest_user).username ?? ""
                returnNewRoom(newRoom)
            } catch(let error) {
                print(error)
            }
        }
    }
    
    func getSessionId() -> UUID {
        session?.user.id ?? UUID()
    }
}
