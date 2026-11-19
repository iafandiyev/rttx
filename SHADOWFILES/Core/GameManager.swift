import Foundation
import SwiftUI
import Combine

@MainActor final class GameManager: ObservableObject {
    @Published var inGame = false
    @Published var mission = Mission.catalog[0]
    @Published var collected: Set<String> = []
    @Published var nearbyEvidence: Evidence?
    @Published var panel: GamePanel?
    @Published var toast: String?
    @Published var move = SIMD2<Float>(repeating: 0)
    @Published var sprinting = false
    @Published var playerName = "Detective"
    let saves = SaveManager()
    let network = NetworkManager()

    init() { collected = saves.loadEvidence() }
    func collect(_ evidence: Evidence) {
        guard collected.insert(evidence.id).inserted else { return }
        saves.saveEvidence(collected)
        toast = "Evidence logged: \(evidence.title)"
        mission.progress = min(mission.objectives.count, mission.progress + 1)
        if mission.progress == mission.objectives.count { toast = "CASE CLOSED — \(mission.title)" }
    }
    func start(_ mission: Mission) { self.mission = mission; inGame = true }
}

enum GamePanel: String, Identifiable { case cases, notebook, map, settings, multiplayer, character; var id: String { rawValue } }
