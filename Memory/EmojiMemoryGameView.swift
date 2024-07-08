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

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
      
    // var activeThemes: [Theme]
    // @State var currentTheme: Theme
//    init() {
//        // activeThemes = [vehicles, sports, weather]
//        //currentTheme = activeThemes[0]
//    }
    
    // Builds main body view
    var body: some View {
        VStack {
            Text(
                "Memorize!"
            ).bold().font(.largeTitle)
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
//            Spacer()
//            themeSelectors()
        }
        .padding()
    }
    
    // Builds dynamic Grid of CardViews based on currently selected theme.
    var cards: some View {
        // let deck = buildDeck(fromCards: currentTheme.cards)

        // best effort dynamic sizing
        let adaptiveMinimum = calculateAdaptiveMinimum(numCards: viewModel.cards.count)
        
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: adaptiveMinimum), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card, smallCard: adaptiveMinimum <= 50 ? true: false)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(.orange) // FIXME: improvement!
        // .foregroundColor(currentTheme.color)
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
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    // render icon smaller
    let smallCard: Bool
    
    init(_ card: MemoryGame<String>.Card, smallCard: Bool) {
        self.card = card
        self.smallCard = smallCard
    }
    
    var body: some View {
        return ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    //.font(.system(size: 200))
                    .font(.system(size: smallCard ? 48 : 64))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }.opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }.opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}


//
//    // Builds list of theme selector buttons.
//    // restricted to themes listed in `activeThemes`
//    func themeSelectors() -> some View {
//        HStack {
//            ForEach(0..<activeThemes.count, id: \.self) { i in
//                let theme = activeThemes[i]
//                themeChanger(toTheme: theme)
//            }
//        }.imageScale(.large)
//        .font(.largeTitle)
//    }
    
    // Button selector for updating current theme.
//    func themeChanger(toTheme: Theme) -> some View {
//        VStack {
//            Button(action: {
//                currentTheme = toTheme
//            }, label: {
//                Image(systemName: toTheme.image)
//                    .foregroundColor(toTheme.color)
//            }
//            ).disabled(currentTheme == toTheme)
//            .frame(maxWidth: .infinity)
//            Text (
//                toTheme.name
//            ).bold().font(.body)
//        }
//    }
