//
//  ExitButton.swift
//  Memory
//
//  Created by Bryan Chapman on 7/11/24.
//

import SwiftUI

struct ExitButton: View {
    var label = "X"
    var onExit: () -> Void
    var showButton: () -> Bool
    
    var body: some View {
        HStack {
            Button(label) {
                onExit()
            } .frame(maxWidth: .infinity, alignment: .trailing).padding().bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }.opacity(showButton() ? 1 : 0)
    }
}

