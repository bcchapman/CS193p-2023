//
//  MemoryApp.swift
//  Memory
//
//  Created by Bryan Chapman on 6/26/24.
//

import SwiftUI

@main
struct MemoryApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
