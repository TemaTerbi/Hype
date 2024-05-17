//
//  AuthorizeServiceProtocol.swift
//  Hype
//
//  Created by Artem Solovev on 17.05.2024.
//

import Foundation
import Supabase

protocol AuthorizeServiceProtocol {
    func buildAuthorizeService(client: SupabaseClient)
    func getSessionsState() -> SigningState
    func invalidSession()
    func checkSession() async
    func sigIn(email: String, password: String) async
    func signUp(email: String, password: String) async
    
    var getSession: Session { get }
    var getClient: SupabaseClient { get }
    var getSiginState: Published<SigningState>.Publisher  { get }
}
