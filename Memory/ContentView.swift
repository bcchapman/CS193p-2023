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
    // TODO: EC3 Dynamic adaptive sizing
    var buildCards: some View {
        let deck = buildDeck(fromCards: currentTheme.cards)

        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<deck.count, id: \.self) { i in
                CardView(content: deck[i], isFaceUp: false)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }.foregroundColor(currentTheme.color)
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
    // Chooses a random subset of cards, unless 4 or less cards exist
    func buildDeck(fromCards: [String]) -> [String] {
        // TODO: Fix with Swift15
//        let numCards =
//        if fromCards.count <= 4 { fromCards.count }
//        else { Int.random(in: 4...fromCards.count) }
        
        // If less than 4 cards, treat as minimum
        // Otherwise select a random number of cards to use from 4 to card count
        var numCards: Int
        if fromCards.count <= 4 { numCards = fromCards.count }
        else { numCards = Int.random(in: 4...fromCards.count) }
        
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
    
    var body: some View {
        return ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.system(size: 64))
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
