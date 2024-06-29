//
//  ContentView.swift
//  Memory
//
//  Created by Bryan Chapman on 6/26/24.
//

import SwiftUI

struct Theme: Equatable {
    let name: String
    let cards: [String]
    let image: String
    let color: Color
}

struct Card {
    let isFaceUp = false
}

struct ContentView: View {
    // Define set of valid themes. These are used to generate buttons
    let vehicles = Theme(name: "Vehicles", cards: ["🚙","🚛","🚑","🚚"], image: "car", color: .red)
    let sports = Theme(name: "Sports", cards: ["⚽️","🏀","🏈","⚾️", "🏒","🏸"], image: "baseball", color: .green)
    let weather = Theme(name: "Weather", cards: ["☀️","⚡️","❄️","🌪️","🌡️"], image: "cloud.bolt.rain.fill", color: .blue)
    
    var activeThemes: [Theme]
    @State var currentTheme: Theme
    init() {
        activeThemes = [vehicles, sports, weather]
        currentTheme = activeThemes[0]
    }
    
    // Builds main body view
    var body: some View {
        VStack {
            Text(
                "Memorize!"
            ).bold().font(.largeTitle)
            ScrollView {
                buildCards
            }
            Spacer()
            themeSelectors()
        }
        .padding()
    }
    
    // Builds dynamic Grid of CardViews based on currently selected theme.
    var buildCards: some View {
        let deck = buildDeck(fromCards: currentTheme.cards)

        // best effort dynamic sizing
        let adaptiveMinimum = calculateAdaptiveMinimum(numCards: deck.count)
        
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: adaptiveMinimum))]) {
            ForEach(0..<deck.count, id: \.self) { i in
                CardView(content: deck[i], isFaceUp: false, smallCard: adaptiveMinimum <= 50 ? true: false)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }.foregroundColor(currentTheme.color)
    }
    
    func calculateAdaptiveMinimum(numCards: Int) -> CGFloat {
        // numCards accounts for pairs, 30 cards -> 15 Pairs
        switch numCards {
        case 1...4:
            120.0
        case 6: // force 3x3
            90.0
        case 5...12:
            80.0
        case 13...30:
            50.0
        // anything over 15 cards is too large for phone
        default:
            80.0
        }
    }
    
    // Builds list of theme selector buttons.
    // restricted to themes listed in `activeThemes`
    func themeSelectors() -> some View {
        HStack {
            ForEach(0..<activeThemes.count, id: \.self) { i in
                let theme = activeThemes[i]
                themeChanger(toTheme: theme)
            }
        }.imageScale(.large)
        .font(.largeTitle)
    }
    
    // Button selector for updating current theme.
    func themeChanger(toTheme: Theme) -> some View {
        VStack {
            Button(action: {
                currentTheme = toTheme
            }, label: {
                Image(systemName: toTheme.image)
                    .foregroundColor(toTheme.color)
            }
            ).disabled(currentTheme == toTheme)
            .frame(maxWidth: .infinity)
            Text (
                toTheme.name
            ).bold().font(.body)
        }
    }
    
    // Generates a new deck of cards including a pair of each provided value.
    // Chooses a random subset of cards, unless 2 or less cards exist
    func buildDeck(fromCards: [String]) -> [String] {
        // If less than 2 cards, treat as minimum
        // Otherwise select a random number of cards to use from 4 to card count
        let numCards =
            if fromCards.count <= 2 { fromCards.count }
            else { Int.random(in: 2...fromCards.count) }
        
        // shuffle cards and take number of desired cards
        let subsetCards = Array(fromCards.shuffled()[0..<numCards])
        
        // generate pairs
        var newCards = subsetCards + subsetCards
        //shuffle cards randomly, does not return new list
        newCards.shuffle()
        return newCards
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    // render icon smaller
    let smallCard: Bool
    
    var body: some View {
        return ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.system(size: smallCard ? 48 : 64))
            }.opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
