//
//  DrinkCardView.swift
//  BottleBounce
//
//  Created by SaiJyotsna on 22/01/26.
//

import Foundation
import SwiftUI

// MARK: - Drink Card View
/// A single animated card shown in the drink list.

struct DrinkCardView: View {
    let drink: Drink
    let index: Int                  // Used for staggered animations
    let animateTrigger: Bool        // External animation reset signal

    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(drink.color.opacity(0.85))
                .frame(height: 100)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    
                    // Star rating with bounce-in animation
                    HStack(spacing: 4) {
                        ForEach(0..<drink.rating, id: \.self) { starIndex in
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                                .scaleEffect(appeared ? 1 : 0)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.6)
                                        .delay(Double(index) * 0.1 + Double(starIndex) * 0.05),
                                    value: appeared
                                )
                        }
                    }

                    Text(drink.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    Text(drink.category)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.leading, 20)
                .offset(x: appeared ? 0 : -50)
                .opacity(appeared ? 1 : 0)

                Spacer()

                // Bottle image slides and rotates in
                Image(drink.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120)
                    .padding(.trailing, 20)
                    .rotationEffect(.degrees(appeared ? 0 : 15))
                    .offset(x: appeared ? 0 : 50)
                    .opacity(appeared ? 1 : 0)
            }
        }
        .scaleEffect(appeared ? 1 : 0.9)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .onAppear {
            // Initial entrance animation
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(Double(index) * 0.1)
            ) {
                appeared = true
            }
        }
        .onChange(of: animateTrigger) { _ in
            // Reset animation when coming back from detail screen
            appeared = false
            DispatchQueue.main.async {
                withAnimation(
                    .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1)
                ) {
                    appeared = true
                }
            }
        }
    }
}
