//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import SwiftUI

// View Model
class EmojiMemoryGame : ObservableObject {
    private static let themes = [
        Theme(name: "Vehicles", cards: ["🚙","🚛","🚑","🚚"], image: "car", color: .red),
        Theme(name: "Sports", cards: ["⚽️","🏀","🏈","⚾️", "🏒","🏸"], image: "baseball", color: .green),
        Theme(name: "Weather", cards: ["☀️","⚡️","❄️","🌪️","🌡️"], image: "cloud.bolt.rain.fill", color: .blue)
    ]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let theme = themes.randomElement()!
        let cards = theme.cards
        let numberOfPairs = cards.count
        return MemoryGame(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return if cards.indices.contains(pairIndex) {
                cards[pairIndex]
            } else {
                "⚠️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    func createNewGame() {
        model = EmojiMemoryGame.createMemoryGame()
        shuffle()
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        return model.choose(card)
    }
}
