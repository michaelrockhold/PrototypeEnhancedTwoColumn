/*
 PrototypeEnhancedTwoColumn © 2024 by Michael Rockhold is licensed under Creative Commons Attribution 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/

Abstract:
#{ABSTRACT}#
*/

import SwiftUI

@main
struct ModelNavigationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}
