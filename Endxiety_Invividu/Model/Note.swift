//
//  Item.swift
//  Endxiety_Invividu
//
//  Created by Ali Haidar on 19/07/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    var id = UUID()
    var content: String
    var fileURL : URL
    var emotion: String
    var editedAt: Date
    var isPlaying : Bool
    
    init(id: UUID = UUID(), content: String, fileURL: URL, emotion: String, editedAt: Date = Date(), isPlaying: Bool) {
        self.id = id
        self.content = content
        self.fileURL = fileURL
        self.emotion = emotion
        self.editedAt = editedAt
        self.isPlaying = isPlaying
    }
}

