//
//  ChatZoneViewModel.swift
//  Hype
//
//  Created by Artem Solovev on 09.05.2024.
//

import Foundation
import Combine

@MainActor
class ChatZoneViewModel: ObservableObject {
    
    @Published var stateOfChatList: StateOfChatList = .emptyList
    @Published private var newRoom: Rooms?
    @Published var roomsList: [Rooms] = []
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        Task {
            await fetchRooms()
            await listeningOnChangeOfRoom()
        }
        
        listenSubscribeOfNewRoomVariable()
    }
    
    func getStateOfChatList() -> StateOfChatList {
        return stateOfChatList
    }
    
    func getRoomsList() -> [Rooms] {
        return roomsList
    }
    
    func fetchRooms() async {
        stateOfChatList = .loadingChats
        let rooms = await SupabaseService.shared.fetchRooms()
        
        DispatchQueue.main.async {
            self.roomsList = rooms.reversed()
            self.changeState()
        }
    }
    
    private func listeningOnChangeOfRoom() async {
        await SupabaseService.shared.startListening { room in
            DispatchQueue.main.async {
                self.newRoom = room
            }
        }
    }
    
    private func listenSubscribeOfNewRoomVariable() {
        $newRoom.sink { newRoom in
            if let _newRoom = newRoom {
                self.roomsList.append(_newRoom)
                self.changeState()
            }
        }.store(in: &bag)
    }
    
    private func changeState() {
        if roomsList.isEmpty {
            stateOfChatList = .emptyList
        } else {
            stateOfChatList = .chatWasLoading
        }
    }
    
    func changeStateOfChatList() {
        stateOfChatList = StateOfChatList.allCases.randomElement() ?? .emptyList
    }
}
