//
//  ContentView.swift
//  Memory
//
//  Created by Bryan Chapman on 6/26/24.
//

import SwiftUI
import EffectsLibrary

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @ObservedObject var memoryTheme: EmojiMemoryTheme
    
    // Builds main body view
    var body: some View {
        VStack {
            HStack {
                Button("X") {
                    viewModel.cancelGame()
                } .frame(maxWidth: .infinity, alignment: .trailing).padding().bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }.opacity(viewModel.gameInProgress ? 1 : 0)
            if !viewModel.gameComplete {
                HStack {
                    Image(systemName: memoryTheme.image)
                    Text (
                        memoryTheme.name
                    )
                    Image(systemName: memoryTheme.image)
                }.bold().font(.largeTitle)
            } else if viewModel.gameInProgress {
                Text("You Win!").bold().font(.largeTitle)
            }
            if !viewModel.gameComplete {
                ScrollView {
                    cards
                        .animation(.default, value: viewModel.cards)
                }
            }
            if viewModel.gameComplete && viewModel.gameInProgress {
                FireworksView (
                    config: FireworksConfig(
                        intensity: .high
                    )
                ).preferredColorScheme(.dark)
            }
            if !viewModel.gameInProgress {
                Button("New Game") {
                    memoryTheme.updateTheme()
                    viewModel.createNewGame(withEmojis: memoryTheme.emojis, withPairCount: memoryTheme.numberOfPairs)
                }.bold().font(.largeTitle)
            }
            if viewModel.gameInProgress {
                Text(
                    "Score: \(viewModel.score)"
                ).bold().font(.largeTitle)
            }
        }
        .padding()
    }
    
    // Builds dynamic Grid of CardViews based on currently selected theme.
    var cards: some View {
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
        .foregroundColor(memoryTheme.color)
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
        EmojiMemoryGameView(viewModel: EmojiMemoryGame(), memoryTheme: EmojiMemoryTheme())
    }
}
