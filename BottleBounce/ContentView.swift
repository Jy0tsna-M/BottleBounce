//
//  ContentView.swift
//  BottleBounce
//
//  Created by SaiJyotsna on 21/11/25.
//

import SwiftUI

// MARK: - Model
/// Represents a single drink item shown in the app.
/// Keeps UI-friendly data (color, imageName) along with display info.

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
// MARK: - Mock Data
/// Static data used to build the UI and animations.
/// Can be replaced with API data later without touching views.
///
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

// MARK: - Content View (Drink List)
// Main entry screen that shows all drinks as animated cards.

struct ContentView: View {
    // Used to replay animations when navigating back from DetailView
    @State private var animateTrigger: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Enumerated so we can stagger animations by index
                    ForEach(Array(drinks.enumerated()), id: \.element.id) { index, drink in
                        NavigationLink(destination: DetailView(drink: drink)) {
                            DrinkCardView(
                                drink: drink,
                                index: index,
                                animateTrigger: animateTrigger
                            )
                            .padding(.horizontal, 12)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Choose Your Drink")
            .navigationBarTitleDisplayMode(.inline)
            
            // Top bar actions (profile + cart)
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
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                // Flip trigger so cards animate again when returning
                animateTrigger.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}

