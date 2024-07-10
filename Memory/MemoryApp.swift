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
    @StateObject var theme = EmojiMemoryTheme()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game, memoryTheme: theme)
        }
    }
}
