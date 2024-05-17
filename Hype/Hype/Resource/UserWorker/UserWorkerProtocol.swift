//
//  UserWorkerProtocol.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import Foundation
import Supabase

protocol UserWorkerProtocol {
    func buildWorker(client: SupabaseClient, authorizeService: AuthorizeServiceProtocol)
    func getCurrentUser() async
    func getCurrentUserBy(id: UUID) async -> Profile
}
