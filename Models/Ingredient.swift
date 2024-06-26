/*
 Copied near-verbatim from Apple sample code; see Apple's LICENSE.txt
 in the LICENCES folder for this sample’s licensing information.

Abstract:
A data model for an ingredient for a given recipe.
*/

import SwiftUI

struct Ingredient: Hashable, Identifiable {
    let id = UUID()
    var description: String
}
