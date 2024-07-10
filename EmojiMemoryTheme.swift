//
//  MemoryTheme.swift
//  Memory
//
//  Created by Bryan Chapman on 7/9/24.
//
import SwiftUI

// ViewModel
class EmojiMemoryTheme : ObservableObject {
    // TODO: add number of pairs to show
    // if number of pairs < number of cards, randomly select
    // if number of pairs >= number of cards use all at least once, then randomly select
    private static func createMemoryTheme() -> MemoryTheme {
        let themes = [
            MemoryTheme(name: "Vehicles", cards: ["🚙","🚛","🚑","🚚"], image: "car", color: "red"),
            MemoryTheme(name: "Sports", cards: ["⚽️","🏀","🏈","⚾️", "🏒","🏸"], image: "baseball", color: "green"),
            MemoryTheme(name: "Weather", cards: ["☀️","⚡️","❄️","🌪️","🌡️"], image: "cloud.bolt.rain.fill", color: "blue")
        ]
        // force unwrap, we know we have at least one
        return themes.randomElement()!
    }
    
    @Published private var model = createMemoryTheme()
    
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
    
    // MARK: - Intents
    func updateTheme() {
        model = EmojiMemoryTheme.createMemoryTheme()
    }
}
