//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import SwiftUI

// View Model
class EmojiMemoryGame : ObservableObject {
    
    private static func createMemoryGame(emojis: [String], pairCount: Int, onMatchAttemptCompleteDo: Optional< () -> Void>) -> MemoryGame<String> {
        // check for uninitialized game
        if pairCount == 0  {
            return MemoryGame()
        }
        
        return MemoryGame(numberOfPairsOfCards: pairCount, onMatchAttemptCompleteDo: onMatchAttemptCompleteDo ?? nil) { pairIndex in
            return if emojis.indices.contains(pairIndex) {
                emojis[pairIndex]
            } else {
                "⚠️"
            }
        }
    }
    
    @Published private var model = createMemoryGame(emojis: [], pairCount: 0, onMatchAttemptCompleteDo: nil)
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var gameInProgress: Bool {
        return model.gameInProgress
    }
    
    // game is complete when no more unmatched cards
    var gameComplete: Bool {
        return !cards.contains(where: {
            !$0.isMatched
        })
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
        
        model = EmojiMemoryGame.createMemoryGame(emojis: fullEmojis, pairCount: withPairCount, onMatchAttemptCompleteDo: onMatchAttemptComplete)
        model.shuffle()
        
        model.toggleGameStatus()
    }
    
    func onMatchAttemptComplete() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.model.clearMatch()
        }
    }
    
    func cancelGame() {
        model.toggleGameStatus()
        model = EmojiMemoryGame.createMemoryGame(emojis: [], pairCount: 0, onMatchAttemptCompleteDo: nil)
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        return model.choose(card)
    }
}
