//
//  ContentView.swift
//  BottleBounce
//
//  Created by SaiJyotsna on 21/11/25.
//

import SwiftUI

// MARK: - Model

struct Drink: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let rating: Int
    let price: Int
    let description: String
    let color: Color
    let imageName: String
    let highlights: [(label: String, value: String)]
}

let drinks: [Drink] = [
    Drink(
        name: "Mountain Dew",
        category: "Soft Drink",
        rating: 4,
        price: 60,
        description: "High-energy citrus taste.",
        color: Color.green,
        imageName: "monDe",
        highlights: [
            ("Brand", "Mountain Dew"),
            ("Product Type", "Soft Drink"),
            ("Flavour", "Lemon"),
            ("Key Features", "High-energy citrus taste, caffeinated, refreshing"),
            ("Weight", "300 ml"),
            ("Ingredients", "Carbonated Water, Sugar, Regulators, Natural Flavouring"),
            ("Allergen Info", "Contains: Caffeine"),
            ("Nutrition Info", "Energy 49 kcal, Carbs 12.3 g, Sugars 12.3 g")
        ]
    ),
    Drink(
        name: "Thums Up",
        category: "Soft Drink",
        rating: 4,
        price: 40,
        description: "Strong and spicy cola flavour.",
        color: Color.blue,
        imageName: "thumup",
        highlights: [
            ("Brand", "Thums Up"),
            ("Product Type", "Soft Drink"),
            ("Key Features", "Strong & spicy cola flavor"),
            ("Weight", "300 ml"),
            ("Ingredients", "Carbonated water, Sugar, Acidity Regulator, Flavours"),
            ("Allergen Info", "Contains: Caffeine"),
            ("Nutrition Info", "Energy 42 kcal, Carbs 10.6 g, Sugars 10.4 g")
        ]
    ),
    Drink(
        name: "CoCoCola",
        category: "Soft Drink",
        rating: 4,
        price: 50,
        description: "Refreshing classic cola taste.",
        color: Color(red: 1.0, green: 0.4, blue: 0.4),
        imageName: "coke2",
        highlights: [
            ("Brand", "Coca Cola"),
            ("Product Type", "Soft Drink"),
            ("Model Name", "Original"),
            ("Key Features", "Refreshing original cola taste, recyclable packaging"),
            ("Weight", "300 ml"),
            ("Ingredients", "Carbonated Water, Sugar, Flavours (Natural), Caffeine"),
            ("Allergen Info", "Contains: Caffeine"),
            ("Nutrition Info", "Energy 44 kcal, Carbs 10.9 g, Sugars 10.6 g")
        ]
    ),
    Drink(
        name: "Monster",
        category: "Energy Drink",
        rating: 4,
        price: 60,
        description: "Monster Energy — grab a can and unleash the beast.",
        color: Color.gray,
        imageName: "monsters",
        highlights: [
            ("Brand", "Monster"),
            ("Product Type", "Energy Drink"),
            ("Key Features", "Boost energy with Taurine and vitamins"),
            ("Weight", "350 ml"),
            ("Ingredients", "Carbonated Water, Sucrose, Taurine, Caffeine"),
            ("Allergen Info", "Contains: Caffeine"),
            ("Nutrition Info", "Energy 48 kcal, Carbs 12 g, Sugars 11 g")
        ]
    ),
    Drink(
        name: "Fanta",
        category: "Soft Drink",
        rating: 4,
        price: 50,
        description: "Vibrant orange flavour with fizzy bubbles.",
        color: Color.orange,
        imageName: "fanta",
        highlights: [
            ("Brand", "Fanta"),
            ("Product Type", "Orange Flavoured Soft Drink"),
            ("Key Features", "Refreshing orange flavour, caffeine-free"),
            ("Weight", "300 ml"),
            ("Ingredients", "Carbonated Water, Sugar, Stabilizers, Flavours"),
            ("Allergen Info", "Contains: Added Flavour"),
            ("Nutrition Info", "Energy 56 kcal per 100 ml, Carbs 14 g")
        ]
    )
]

// MARK: - Content View (Order List)

struct ContentView: View {
    @State private var animateTrigger: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(drinks.enumerated()), id: \.element.id) { index, drink in
                        NavigationLink(destination: DetailView(drink: drink)) {
                            DrinkCardView(drink: drink, index: index, animateTrigger: animateTrigger)
                                .padding(.horizontal, 12)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Choose Your Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image("profileIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "cart")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                // flip trigger to replay list animations when returning
                animateTrigger.toggle()
            }
        }
    }
}

// MARK: - Drink Card View

struct DrinkCardView: View {
    let drink: Drink
    let index: Int
    let animateTrigger: Bool

    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(drink.color.opacity(0.85))
                .frame(height: 100)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<drink.rating, id: \.self) { starIndex in
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .scaleEffect(appeared ? 1.0 : 0.0)
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

                Image(drink.imageName)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 120)
                    .padding(.trailing, 20)
                    .rotationEffect(.degrees(appeared ? 0 : 15))
                    .offset(x: appeared ? 0 : 50)
                    .opacity(appeared ? 1 : 0)
            }
        }
        .scaleEffect(appeared ? 1.0 : 0.9)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onAppear {
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(Double(index) * 0.1)
            ) {
                appeared = true
            }
        }
        .onChange(of: animateTrigger) { _ in
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

// MARK: - Detail View

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
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(drink.color.opacity(0.85))
                        .frame(height: 240)
                        .padding(.horizontal)
                        .scaleEffect(appeared ? 1.0 : 0.8)
                        .opacity(appeared ? 1.0 : 0.0)
                    
                    HStack(spacing: 30) {
                        if isExpanded {
                            BottleImageView(imageName: drink.imageName, delay: 0.0, position: 0, isExpanded: isExpanded)
                            BottleImageView(imageName: drink.imageName, delay: 0.1, position: 1, isExpanded: isExpanded)
                            BottleImageView(imageName: drink.imageName, delay: 0.2, position: 2, isExpanded: isExpanded)
                        } else {
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

// MARK: - Bottle Image View

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
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    appear = newValue
                }
            }
    }
}

#Preview {
    ContentView()
}

