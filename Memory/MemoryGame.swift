//
//  MemorizeGame.swift
//  Memory
//
//  Created by Bryan Chapman on 6/29/24.
//

import Foundation

// Model
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        if(numberOfPairsOfCards > 0) {
            // add numberOfPairsOfCards x 2 cards
            for pairIndex in 0..<max(2, numberOfPairsOfCards) {
                let content = cardContentFactory(pairIndex)
                cards.append(Card(content:content, id: "\(pairIndex+1)a"))
                cards.append(Card(content: content, id: "\(pairIndex+1)b"))
            }
        }
    }
    
    // which card has been flipped and not yet evaluated
    var indexOfSelectedCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach{ cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            // only choose if card is not yet chosen or matched
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                // we have a previously selected card
                if let potentialMatchIndex = indexOfSelectedCard {
                    // we have a match, set matched
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        
                        // increase score
                        score += 2
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                    // mark hasBeenSeen after scoring
                    cards[potentialMatchIndex].hasBeenSeen = true
                    cards[chosenIndex].hasBeenSeen = true
                    // FIXME: Hide match after timeout
                } else { // no selected card
                    // set selected card
                    indexOfSelectedCard = chosenIndex
                }
                // update selected card face up
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id): \(content) \(hasBeenSeen ? "seen" : "not seen") \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }
        
        let content: CardContent
        var hasBeenSeen = false
        var isFaceUp = false
        var isMatched = false
        
        // less important, move to bottom
        var id: String
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
