//
//  SuccessEmojiButton.swift
//  Statement
//
//  Created by Stef Kors on 10/05/2023.
//

import SwiftUI

struct SuccessEmojiButton: View {
    @State private var chosenEmoji: String = ""
    @State private var isVisible: Bool = false

    let label: String

    let callback: () -> Void

    var body: some View {
        ZStack {
            Button {
                chosenEmoji = String.SuccessEmoji.randomElement() ?? "🎁"
            } label: {
                Text(label)
            }
            .font(.system(size: 11))

            Text(chosenEmoji)
                .font(.system(size: 36))
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? -40 : 0)
                .scaleEffect(x: isVisible ? 1 : 0, y: isVisible ? 1 : 0)
                .allowsHitTesting(false)
        }
        .frame(height: 20)
        .onChange(of: chosenEmoji) { newValue in
            let animation: Animation = .interpolatingSpring(stiffness: 130, damping: 12)
            withAnimation(animation) {
                isVisible = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                withAnimation(animation) {
                    isVisible = false
                }
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                callback()
            })
        }
    }
}

extension String {
    static let SuccessEmoji = ["🎉", "🥳", "🎊"]
}
