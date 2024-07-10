//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import SwiftUI

// View Model
class EmojiMemoryGame : ObservableObject {
    private static func createMemoryGame(withEmojis: [String]? = nil) -> MemoryGame<String> {
        
        // check for uninitialized game
        guard let emojis = withEmojis else {
            return MemoryGame(numberOfPairsOfCards: 0) {_ in 
                ""
            }
        }
        
        let numberOfPairs = max(2, Int.random(in:  2 ... emojis.count))
        return MemoryGame(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return if emojis.indices.contains(pairIndex) {
                emojis[pairIndex]
            } else {
                "⚠️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intents
    func createNewGame(fromEmojis: [String]) {
        model = EmojiMemoryGame.createMemoryGame(withEmojis: fromEmojis)
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        return model.choose(card)
    }
}
