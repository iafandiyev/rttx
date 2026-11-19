import SwiftUI
import RealityKit

struct GameView: View {
    @EnvironmentObject private var game: GameManager
    @State private var scene = GameSceneManager()
    var body: some View {
        ZStack {
            RealityView { content in scene.build(into: content, evidence: Evidence.city, game: game) }
                .ignoresSafeArea().gesture(DragGesture(minimumDistance: 8).onChanged { value in scene.look(delta: SIMD2(Float(value.translation.width), Float(value.translation.height))) }.onEnded { _ in scene.endLook() })
                .overlay(alignment: .topLeading) { VStack(alignment: .leading, spacing: 4) { Text("SHADOW FILES  /  GREYWOOD").font(.caption.bold()).tracking(2).foregroundStyle(.red); Text(game.mission.title).font(.headline); Text(game.mission.objectives[safe: game.mission.progress] ?? "Investigation complete").font(.caption).foregroundStyle(.white.opacity(0.7)) }.padding(14).background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 12)).padding() }
            VStack { Spacer(); HStack(alignment: .bottom) {
                VirtualJoystick(value: $game.move).frame(width: 132,height: 132).padding(.leading,20)
                Spacer()
                VStack(spacing: 12) {
                    Button { game.sprinting.toggle() } label: { hudButton(game.sprinting ? "RUNNING" : "SPRINT", icon:"figure.run") }
                    Button { if let e = game.nearbyEvidence { game.collect(e) } else { game.toast = "Nothing to inspect nearby" } } label: { hudButton("INSPECT", icon:"scope") }.disabled(game.nearbyEvidence == nil)
                    HStack { hudTool("NOTEBOOK","book.closed",.notebook); hudTool("MAP","map",.map); hudTool("CASES","folder",.cases); hudTool("ONLINE","person.2",.multiplayer) }
                }.padding(.trailing,18).padding(.bottom,12)
            } }
            if let e = game.nearbyEvidence { VStack { Spacer(); Text("◉  \(e.title)  ·  tap INSPECT").font(.subheadline.bold()).padding(12).background(.black.opacity(0.75),in:Capsule()).padding(.bottom,164) } }
            if let toast = game.toast { VStack { Spacer(); Text(toast).font(.subheadline.bold()).padding().background(.red.opacity(0.88),in:RoundedRectangle(cornerRadius:12)).padding(.bottom,250) }.task { try? await Task.sleep(for:.seconds(2)); game.toast = nil } }
            if let panel = game.panel { GamePanelView(panel: panel).environmentObject(game) }
        }.statusBarHidden()
    }
    private func hudButton(_ title:String, icon:String)->some View { Label(title,systemImage:icon).font(.caption.bold()).padding(12).background(.black.opacity(0.75),in:Capsule()).foregroundStyle(.white) }
    private func hudTool(_ title:String,_ icon:String,_ panel:GamePanel)->some View { Button { game.panel = panel } label: { VStack { Image(systemName:icon); Text(title).font(.system(size:8,weight:.bold)) }.frame(width:55,height:48).background(.black.opacity(0.72),in:RoundedRectangle(cornerRadius:9)) } }
}

private extension Collection { subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil } }
