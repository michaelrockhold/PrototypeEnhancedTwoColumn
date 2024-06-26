/*
 NavigationSplitPlusNavigationStackDetails.swift
 Created by Michael Rockhold on 6/24/24.

 PrototypeEnhancedTwoColumn © 2024 by Michael Rockhold is licensed under Creative Commons Attribution 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/

Abstract:
 The content view for the enhanced two-column navigation split view experience.
 The overlong name gives a hint: this is a model for how to build a kind of two-column
 view that I like:
 1) the Sidebar provides a variety of possible single selections, in this case
    "stylesheets" and "recipes", organised into sections;
 2) there is no "content" view
 3) the details view is a navigation stack that allows an arbitrarily deep, recursive,
    trip into the data.

 An interesting thing that took me a while to appreciate is that there are two
 different but interacting kinds of navigation going on here. When the user taps
 on an item in the sidebar, navigation happens because the NavigationLinks in the
 content area update the selection; the details view has to inspect the selection
 to know what to display. When the user taps on a recursive NavigationLink nested
 somewhere in the details view (eg the one in RecipesViews), that activates
 the navigationDestination provided in the NavigationStack immediately inside
 the details closure. Don't attach the navigationDestination to a view that is
 recursively replicated inside that NavigationStack! You just need the one. That's
 why this navigationDestination is here and not attached to (eg) the RecipeView
 inside RecipesView.

 The other thing that you'll need to know is that supporting a variety of
 different kinds of items in the sidebar easiest done by introducing a kind of
 "wrapper" enum, with a case for each sort of thing that might appear in that
 hierarchical list. This enum type will be the type of your "selection" state
 var, and it will be the type of your "value" argument in your content-view
 NavigationLinks (but you don't need to use it for NavigationLinks outside the
 content-view, like in (here) RecipesView.

 If you need to handle multiple selection, make the type of your selection state
 var 'Set<MyWrapperEnum>' rather than 'MyWrapperEnum?', and in your details-view
 closure you need to consider that when you inspect the selection to know what
 to present in the details column.

 Nota Bene: it's common to use the Model type of the data being displayed as the
 base type in the NavigationPath for the NavigationStack. But if you're displaying
 disparate types in the sidebar, you can just use the type-erased convenience
 of NavigationPath().
*/

import SwiftUI

enum TopLevel: Hashable {
    case Stylesheet(String)
    case Recipe(Recipe)
}

struct NavigationSplitPlusNavigationStackDetails: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    var categories = Category.allCases
    var dataModel = DataModel.shared

    @State var selection: TopLevel? = TopLevel.Recipe(DataModel.shared.recipeOfTheDay)

    @State var navPath = NavigationPath()

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section {
                    ForEach(["Monotone", "Default", "Electric", "Discrete"], id: \.self) { stylesheet in
                        NavigationLink(stylesheet, value: TopLevel.Stylesheet(stylesheet))
                    }
                } header: {
                    Text("Stylesheets")
                }

                ForEach(categories) { category in
                    Section {
                        ForEach(dataModel.recipes(in: category)) { recipe in
                            NavigationLink(recipe.name, value: TopLevel.Recipe(recipe))
                        }
                    } header: {
                        Text(category.localizedName)
                    }
                }
            }
            .navigationTitle("Everything")
        } detail: {
            NavigationStack(path: $navPath) {
                if let selection = selection {
                    switch selection {
                    case .Recipe(let r):
                        RecipesView(recipe: r)
                            .navigationDestination(for: Recipe.self) { nested in
                                    RecipesView(recipe: nested)
                            }
                    case .Stylesheet(let s):
                        Text("stylesheet \(s)")
                    }
                } else {
                    Text("no selection")
                }
            }
        }
    }
}

struct NavigationSplitPlusNavigationStackDetails_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationSplitPlusNavigationStackDetails(dataModel: .shared)
            NavigationSplitPlusNavigationStackDetails(dataModel: .shared)
            NavigationSplitPlusNavigationStackDetails(dataModel: .shared)
                .environmentObject(NavigationModel(recipePath: [.mock]))
        }
    }
}