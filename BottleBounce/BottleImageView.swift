//
//  BottleImageView.swift
//  BottleBounce
//
//  Created by SaiJyotsna on 22/01/26.
//

import Foundation
import SwiftUI

// MARK: - Bottle Image View
/// Handles bottle entrance, rotation, and floating animation.

struct BottleImageView: View {
    let imageName: String
    let delay: Double
    let position: Int
    let isExpanded: Bool
    @State private var appear = false
    @State private var floating = false

    var rotation: Double {
        if !isExpanded { return 0 }
        switch position {
        case 0: return -15
        case 2: return 15
        default: return 0
        }
    }

    var xOffset: CGFloat {
        if !isExpanded { return 0 }
        switch position {
        case 0: return -10
        case 2: return 10
        default: return 0
        }
    }

    var floatingOffset: CGFloat {
        switch position {
        case 0: return floating ? -8 : 8
        case 2: return floating ? 8 : -8
        default: return floating ? -5 : 5
        }
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 160)
            .rotationEffect(.degrees(appear ? rotation : 0), anchor: .bottom)
            .offset(x: appear ? xOffset : 0)
            .offset(y: floatingOffset)
            .scaleEffect(appear ? 1.0 : 0.3)
            .opacity(appear ? 1.0 : 0.0)
            .onAppear {
                // Entrance animation
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                    appear = true
                }
                // continuous floating
                withAnimation(
                    .easeInOut(duration: 2.0 + Double(position) * 0.2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    floating = true
                }
            }
            .onChange(of: isExpanded) { newValue in
                // Sync visibility with expanded state/
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    appear = newValue
                }
            }
    }
}
