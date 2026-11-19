import SwiftUI

@main
struct ShadowFilesApp: App {
    @StateObject private var game = GameManager()
    var body: some Scene {
        WindowGroup { AppCoordinator().environmentObject(game).preferredColorScheme(.dark) }
    }
}
