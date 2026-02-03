//
//  DetailView.swift
//  BottleBounce
//
//  Created by SaiJyotsna on 22/01/26.
//

import Foundation
import SwiftUI

// MARK: - Detail View
/// Full product screen with expandable bottles and cart controls.

struct DetailView: View {
    let drink: Drink
    @State private var isExpanded = false
    @State private var quantity = 0
    @State private var appeared = false
    @State private var bottlesBounce = false
    @State private var showHighlightsLocal = true
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            drink.color.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bottle showcase
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(drink.color.opacity(0.85))
                        .frame(height: 240)
                        .padding(.horizontal)
                        .scaleEffect(appeared ? 1.0 : 0.8)
                        .opacity(appeared ? 1.0 : 0.0)
                    
                    HStack(spacing: 30) {
                        if isExpanded {
                            // Expanded: show multiple bottles
                            BottleImageView(imageName: drink.imageName, delay: 0.0, position: 0, isExpanded: isExpanded)
                            BottleImageView(imageName: drink.imageName, delay: 0.1, position: 1, isExpanded: isExpanded)
                            BottleImageView(imageName: drink.imageName, delay: 0.2, position: 2, isExpanded: isExpanded)
                        } else {
                            // Collapsed: single bottle
                            BottleImageView(imageName: drink.imageName, delay: 0.0, position: 1, isExpanded: isExpanded)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 1.2).combined(with: .opacity),
                                    removal: .scale(scale: 0.8).combined(with: .opacity)
                                ))
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, 8)
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(drink.name)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.black)
                            .offset(x: appeared ? 0 : -10)
                            .opacity(appeared ? 1 : 0)
                        Text(drink.category)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .offset(x: appeared ? 0 : -10)
                            .opacity(appeared ? 1 : 0)
                    }
                    .padding(.leading, 18)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(0..<drink.rating, id: \.self) { idx in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 24))
                                .scaleEffect(appeared ? 1.0 : 0.0)
                                .rotationEffect(.degrees(appeared ? 0 : 180))
                        }
                    }
                    .padding(.trailing, 18)
                }
                .padding(.top, 32)
                .padding(.bottom, 8)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Highlights")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showHighlightsLocal.toggle()
                            }
                        }) {
                            Image(systemName: showHighlightsLocal ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    .padding(.bottom, 10)
                    
                    if showHighlightsLocal {
                        VStack(spacing: 12) {
                            ForEach(Array(drink.highlights.enumerated()), id: \.offset) { _, pair in
                                HStack(alignment: .top) {
                                    Text(pair.label)
                                        .foregroundColor(.gray)
                                        .frame(width: 120, alignment: .leading)
                                        .font(.system(size: 14))
                                    Text(pair.value)
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 4)
                )
                .padding(.horizontal, 12)
                .padding(.top, 6)
                
                Spacer(minLength: 12)

                VStack {
                    Spacer()

                    HStack(spacing: 12) {
                        let totalPrice = quantity > 0 ? drink.price * quantity : drink.price
                        Text("\(totalPrice) Rs")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 18)
                            .animation(.easeInOut, value: totalPrice)

                        Spacer()

                        if quantity == 0 {
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    quantity = 1
                                }
                            }) {
                                Text("Add to cart")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(drink.color)
                            )
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                            .padding(.trailing, 18)
                            .padding(.vertical, 6)

                        } else {
                            HStack(spacing: 20) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if quantity > 0 { quantity -= 1 }
                                    }
                                }) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: "minus")
                                                .foregroundColor(.black)
                                        )
                                }

                                Text("\(quantity)")
                                    .font(.system(size: 22, weight: .bold))
                                    .frame(width: 30)
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        quantity += 1
                                    }
                                }) {
                                    Circle()
                                        .fill(drink.color)
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                            .padding(.trailing, 18)
                            .padding(.vertical, 6)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, (UIApplication.shared.connectedScenes
                                        .compactMap { $0 as? UIWindowScene }
                                        .first?.windows.first?.safeAreaInsets.bottom ?? 12) + 12)
                }
                .ignoresSafeArea(edges: .bottom)

            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.title2)
        })
        .onAppear {
            // Entry animation + auto-expand bottles
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isExpanded = true
                }
            }
        }
    }
}
