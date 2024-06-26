/*
 Copied near-verbatim from Apple sample code; see Apple's LICENSE.txt
 in the LICENCES folder for this sample’s licensing information.

Abstract:
 Lightweight wrapper view that injects the navigation model and
 wraps an initialization task onto the real main view.
*/

import SwiftUI

struct ContentView: View {
    @SceneStorage("navigation") private var navigationData: Data?
    @StateObject private var navigationModel = NavigationModel()

    var body: some View {
        NavigationSplitPlusNavigationStackDetails()
        .environmentObject(navigationModel)
        .task {
            if let jsonData = navigationData {
                navigationModel.jsonData = jsonData
            }
            for await _ in navigationModel.objectWillChangeSequence {
                navigationData = navigationModel.jsonData
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
