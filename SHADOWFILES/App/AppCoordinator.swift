import SwiftUI

struct AppCoordinator: View {
    @EnvironmentObject private var game: GameManager
    var body: some View {
        Group {
            if game.inGame { GameView() }
            else { MainMenuView() }
        }.animation(.easeInOut(duration: 0.35), value: game.inGame)
    }
}
