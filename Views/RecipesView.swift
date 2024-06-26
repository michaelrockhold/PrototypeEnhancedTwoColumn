/*
 RecipesView.swift
 Created by Michael Rockhold on 6/24/24.

 PrototypeEnhancedTwoColumn © 2024 by Michael Rockhold is licensed under Creative Commons Attribution 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/

Abstract:
 Convenience view as separate View struct and file, because I don't know how to do inline convenience views yet
*/

import SwiftUI

struct RecipesView: View {
    let recipe: Recipe

    var body: some View {
        RecipeDetail(recipe: recipe) { relatedRecipe in
            NavigationLink(value: relatedRecipe) {
                RecipeTile(recipe: relatedRecipe)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    RecipesView(recipe: Recipe.mock)
}
