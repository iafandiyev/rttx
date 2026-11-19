import Foundation
enum GameConfiguration {
    static let serverURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "SHADOW_SERVER_URL") as? String ?? "ws://127.0.0.1:8080/game")!
    static let worldRadius: Float = 90
    static let interactionDistance: Float = 5
}
