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
    
    private let aspectRatio: CGFloat = 2/3
    
    // Builds main body view
    var body: some View {
        VStack {
            ExitButton (
                onExit: { viewModel.cancelGame() },
                showButton: { viewModel.gameInProgress }
            )
            title
            cards
            gameControls
        }
        .padding()
        .edgesIgnoringSafeArea([.top])
    }
    
    // Builds dynamic Grid of CardViews based on currently selected theme.
    @ViewBuilder
    private var cards: some View {
        if !viewModel.gameComplete {
            AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
                CardView(card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
            .foregroundColor(memoryTheme.color)
            .animation(.default, value: viewModel.cards)
        }
    }
    
    // Build title view
    private var title: some View {
        return HStack {
            if !viewModel.gameComplete {
                Image(systemName: memoryTheme.image)
                Text (
                    memoryTheme.name
                )
                Image(systemName: memoryTheme.image)
            } else if viewModel.gameInProgress {
                Text("You Win!")
            }
        }.bold().font(.largeTitle)
    }
    
    // builds new game button, current score display and success screen
    // depending on state of play
    @ViewBuilder
    private var gameControls: some View {
        if viewModel.gameInProgress {
            if viewModel.gameComplete {
                if viewModel.gameComplete {
                    FireworksView (
                        config: FireworksConfig(
                            intensity: .high
                        )
                    ).preferredColorScheme(.dark)
                }
            }
            else {
                Text(
                    "Score: \(viewModel.score)"
                ).bold().font(.largeTitle)
            }
        }
        else {
            Button("New Game") {
                memoryTheme.updateTheme()
                viewModel.createNewGame(withEmojis: memoryTheme.emojis, withPairCount: memoryTheme.numberOfPairs)
            }.bold().font(.largeTitle)
        }
    }
}

private struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        return ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
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
