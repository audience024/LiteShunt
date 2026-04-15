import SwiftUI

@main
struct LiteShuntApp: App {
    var body: some Scene {
        WindowGroup("LiteShunt") {
            StatusView()
        }
        .defaultSize(width: 480, height: 300)
    }
}
