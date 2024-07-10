//
//  MemoryTheme.swift
//  Memory
//
//  Created by Bryan Chapman on 7/9/24.
//
import SwiftUI

// ViewModel
class EmojiMemoryTheme : ObservableObject {
    private static func fetchRandomTheme() -> MemoryTheme {
        let themes = [
            MemoryTheme(name: "Vehicles", cards: ["🚙","🚛","🚑","🚚"], image: "car", color: "red", numberOfPairs: 4),
            MemoryTheme(name: "Sports", cards: ["⚽️","🏀","🏈","⚾️", "🏒","🏸"], image: "baseball", color: "green", numberOfPairs: 6),
            MemoryTheme(name: "Weather", cards: ["☀️","⚡️","❄️","🌪️","🌡️"], image: "cloud.bolt.rain.fill", color: "blue", numberOfPairs: 6)
        ]
        // force unwrap, we know we have at least one
        return themes.randomElement()!
    }
    
    @Published private var model = fetchRandomTheme()
    
    var name: String {
        return model.name
    }
    
    var emojis: Array<String> {
        return model.cards
    }
    
    var color: Color {
        return switch model.color {
        case "blue":
                .blue
        case "green":
                .green
        case "orange":
                .orange
        case "red":
                .red
        case "yellow":
                .yellow
        default:
            .orange
        }
    }
    
    var image: String {
        return model.image
    }
    
    var numberOfPairs: Int {
        return model.numberOfPairs
    }
    
    // MARK: - Intents
    func updateTheme() {
        model = EmojiMemoryTheme.fetchRandomTheme()
    }
}
