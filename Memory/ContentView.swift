//
//  ContentView.swift
//  Memory
//
//  Created by Bryan Chapman on 6/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            let emojis = ["👻", "🎃", "🕷️", "😈"]
            ForEach(emojis.indices, id: \.self) { i in
                CardView(content: emojis[i], isFaceUp: i == 0 ? true : false)
            }
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            else {
                base.fill()
            }
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
