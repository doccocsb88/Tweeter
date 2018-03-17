//
//  MessageViewModel.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
struct State {
    enum EditingStyle {
        case insert(Message)
        case delete(IndexPath)
        case none
    }
    
    var messages: [Message]
    var editingStyle: EditingStyle {
        didSet {
            switch editingStyle {
            case let .insert(new):
                messages.append(new)
            case let .delete(indexPath):
                messages.remove(at: indexPath.row)
            default:
                break
            }
        }
    }
    
    init(messages: [Message]) {
        self.messages = messages
        self.editingStyle = .none
    }
    
    func text(at indexPath: IndexPath) -> String {
        return "\(messages[indexPath.row])"
    }
    
}
final class MessageViewModel {
    
    private(set) var state = State(messages: []) {
        didSet {
            callback(state)
        }
    }
    let callback: (State) -> ()
    init(callback: @escaping (State) -> ()) {
        self.callback = callback
    }
    func addNewMessage(message:Message) {
        state.editingStyle = .insert(message)
    }
    func fetchMessages() {
        self.state.messages = CoredataService.shared().getListMessage()
        state.editingStyle = .none
        
        
    }
    
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return state.messages.count
    }
    func message(at indexPath: IndexPath) -> Message{
        return state.messages[indexPath.row]
    }
}
