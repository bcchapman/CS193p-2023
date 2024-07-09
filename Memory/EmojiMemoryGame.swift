//
//  EmojiMemoryGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import SwiftUI

// View Model
class EmojiMemoryGame : ObservableObject {
    private static let emojis =  ["⚽️","🏀","🏈","⚾️", "🏒","🏸"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 6) { pairIndex in
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
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        return model.choose(card)
    }
}

//TODO
// Define set of valid themes. These are used to generate buttons
// TODO move to EmojiMemoryGame
//    let vehicles = Theme(name: "Vehicles", cards: ["🚙","🚛","🚑","🚚"], image: "car", color: .red)
//    let sports = Theme(name: "Sports", cards: ["⚽️","🏀","🏈","⚾️", "🏒","🏸"], image: "baseball", color: .green)
//    let weather = Theme(name: "Weather", cards: ["☀️","⚡️","❄️","🌪️","🌡️"], image: "cloud.bolt.rain.fill", color: .blue)
//  


// Generates a new deck of cards including a pair of each provided value.
// Chooses a random subset of cards, unless 2 or less cards exist
//func buildDeck(fromCards: [String]) -> [String] {
//    // If less than 2 cards, treat as minimum
//    // Otherwise select a random number of cards to use from 4 to card count
//    let numCards =
//        if fromCards.count <= 2 { fromCards.count }
//        else { Int.random(in: 2...fromCards.count) }
//    
//    // shuffle cards and take number of desired cards
//    let subsetCards = Array(fromCards.shuffled()[0..<numCards])
//    
//    // generate pairs
//    var newCards = subsetCards + subsetCards
//    //shuffle cards randomly, does not return new list
//    newCards.shuffle()
//    return newCards
//}
