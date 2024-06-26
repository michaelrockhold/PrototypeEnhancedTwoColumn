/*
 Copied near-verbatim from Apple sample code; see Apple's LICENSE.txt
 in the LICENCES folder for this sample’s licensing information.

Abstract:
A navigation model used to persist and restore the navigation state.
*/

import SwiftUI
import Combine

final class NavigationModel: ObservableObject, Codable {
    @Published var recipePath: [Recipe]
    @Published var stylesheetPath: [String]

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    init(recipePath: [Recipe] = [], stylesheetPath: [String] = []) {
        self.recipePath = recipePath
        self.stylesheetPath = stylesheetPath
    }

    var selectedRecipe: Recipe? {
        get { recipePath.first }
        set { recipePath = [newValue].compactMap { $0 } }
    }

    var jsonData: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let data = newValue,
                  let model = try? decoder.decode(Self.self, from: data)
            else { return }
            recipePath = model.recipePath
        }
    }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recipePathIds = try container.decode([Recipe.ID].self, forKey: .recipePathIds)
        self.recipePath = recipePathIds.compactMap { DataModel.shared[$0] }
        self.stylesheetPath = [String]()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recipePath.map(\.id), forKey: .recipePathIds)
    }

    enum CodingKeys: String, CodingKey {
        case recipePathIds
    }
}
