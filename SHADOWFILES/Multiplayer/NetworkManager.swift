import Foundation
import Combine
@MainActor final class NetworkManager: ObservableObject {
    @Published private(set) var connected = false
    private var socket: URLSessionWebSocketTask?
    private var sequence = 0
    private var endpoint = GameConfiguration.serverURL
    func configure(_ url:URL) { endpoint=url }
    func connect() async throws { let task=URLSession.shared.webSocketTask(with:endpoint); task.resume(); socket=task; connected=true; Task { await receiveLoop() }; try await send(type:"authenticate",payload:["player_id":UUID().uuidString,"display_name":"Detective"]) }
    func send(type:String,payload:[String:String]=[:]) async throws { sequence += 1; let data=try JSONSerialization.data(withJSONObject:["type":type,"sequence":sequence,"payload":payload]); guard let socket else { throw URLError(.notConnectedToInternet) }; try await socket.send(.data(data)) }
    private func receiveLoop() async { guard let socket else{return}; do { while true { _ = try await socket.receive() } } catch { connected=false; self.socket=nil } }
}
