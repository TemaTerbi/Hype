//
//  DatabaseServiceProtocol.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import Foundation
import Supabase

protocol DatabaseServiceProtocol {
    func buildDatabaseService(client: SupabaseClient, authorizeService: AuthorizeServiceProtocol, userWorker: UserWorkerProtocol)
    func fetchProfiles() async -> [Profile]
    func fetchRooms() async -> [Rooms]
    func insertNewRoom(guestUserId: UUID) async
}
