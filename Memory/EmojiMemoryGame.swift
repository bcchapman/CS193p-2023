//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import SwiftUI

// View Model
class EmojiMemoryGame : ObservableObject {
    
    private static func createMemoryGame(emojis: [String], pairCount: Int) -> MemoryGame<String> {
        // check for uninitialized game
        if pairCount == 0  {
            return MemoryGame(numberOfPairsOfCards: 0) {_ in
                ""
            }
        }
        
        return MemoryGame(numberOfPairsOfCards: pairCount) { pairIndex in
            return if emojis.indices.contains(pairIndex) {
                emojis[pairIndex]
            } else {
                "⚠️"
            }
        }
    }
    
    @Published private var model = createMemoryGame(emojis: [], pairCount: 0)
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var gameInProgress: Bool {
        return model.gameInProgress
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intents
    func createNewGame(withEmojis: [String], withPairCount: Int) {
        var fullEmojis = withEmojis.shuffled()
        
        // while we don't have enough emojis, add a random element
        while fullEmojis.count < withPairCount {
            fullEmojis.append(withEmojis.randomElement()!)
        }
        
        model = EmojiMemoryGame.createMemoryGame(emojis: fullEmojis, pairCount: withPairCount)
        model.shuffle()
        
        model.toggleGameStatus()
    }
    
    func cancelGame() {
        model.toggleGameStatus()
        model = EmojiMemoryGame.createMemoryGame(emojis: [], pairCount: 0)
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        return model.choose(card)
    }
}
