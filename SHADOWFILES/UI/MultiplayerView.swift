import SwiftUI
struct MultiplayerView: View {
    @EnvironmentObject private var game: GameManager
    @State private var address = "ws://127.0.0.1:8080/game"
    @State private var room = ""
    @State private var status = "Offline mode available"
    var body: some View { VStack(alignment:.leading,spacing:12) { Text("ONLINE CO-OP").font(.caption.bold()).tracking(2).foregroundStyle(.red); TextField("ws://server:8080/game",text:$address).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never); TextField("Room code",text:$room).textFieldStyle(.roundedBorder).textInputAutocapitalization(.characters); HStack { Button("CREATE ROOM") { connect(create:true) }.buttonStyle(.borderedProminent).tint(.red); Button("JOIN") { connect(create:false) }.buttonStyle(.bordered) }; Text(status).font(.caption).foregroundStyle(.secondary); Text("Co-op supports 2–8 detectives. Host a backend with Backend/README.md.").font(.caption2).foregroundStyle(.secondary) }.onAppear { if let u=URL(string:address) { game.network.configure(u) } } }
    private func connect(create:Bool) { guard let url=URL(string:address) else { status="Invalid server address"; return }; game.network.configure(url); Task { do { try await game.network.connect(); try await game.network.send(type:create ? "create_room":"join_room",payload:["code":room]); status="Connected. Waiting for detectives…" } catch { status="Server unavailable · offline case remains playable" } } }
}
