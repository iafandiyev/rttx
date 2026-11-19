import SwiftUI
struct GamePanelView: View {
    @EnvironmentObject private var game: GameManager
    let panel: GamePanel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack { ScrollView { VStack(alignment:.leading,spacing:16) {
            switch panel {
            case .cases: ForEach(Mission.catalog) { m in Button { game.mission=m; if !game.inGame { game.inGame=true }; dismiss() } label: { VStack(alignment:.leading,spacing:8) { Text(m.subtitle.uppercased()).font(.caption.bold()).tracking(1.5).foregroundStyle(.red); Text(m.title).font(.title2.bold()); Text(m.summary).font(.subheadline).foregroundStyle(.white.opacity(0.65)); ProgressView(value:Double(m.progress),total:Double(m.objectives.count)).tint(.red) }.padding().frame(maxWidth:.infinity,alignment:.leading).background(.white.opacity(0.06),in:RoundedRectangle(cornerRadius:12)) }.buttonStyle(.plain) }
            case .notebook: Text("CASE: \(game.mission.title)").font(.headline); Text("FIELD EVIDENCE").font(.caption.bold()).tracking(2).foregroundStyle(.red); ForEach(Evidence.city.filter{$0.caseID == game.mission.id}) { e in HStack { Image(systemName:game.collected.contains(e.id) ? "checkmark.seal.fill" : "circle.dashed").foregroundStyle(game.collected.contains(e.id) ? .green : .gray); VStack(alignment:.leading) { Text(e.title).bold(); Text(game.collected.contains(e.id) ? e.detail : "Uncollected lead").font(.caption).foregroundStyle(.secondary) } } }; Text("SUSPECTS").font(.caption.bold()).tracking(2).foregroundStyle(.red); Text("Mara Voss · Property manager").bold(); Text("Elias Rook · Dock foreman").bold(); Text("CASE TIMELINE").font(.caption.bold()).tracking(2).foregroundStyle(.red); ForEach(Array(game.mission.objectives.enumerated()),id:\.offset) { i,item in Label(item,systemImage:i < game.mission.progress ? "checkmark.circle.fill":"circle").foregroundStyle(i < game.mission.progress ? .green : .secondary) }
            case .map: Text("GREYWOOD DISTRICTS").font(.caption.bold()).tracking(2).foregroundStyle(.red); ForEach([("DOWNTOWN","Civic center and Greywood PD"),("OLD TOWN","Apartment blocks and narrow lanes"),("INDUSTRIAL","Warehouse row · Pier 14"),("RESIDENTIAL","North Hill neighborhood")],id:\.0) { district in HStack { Image(systemName:"location.fill").foregroundStyle(.red); VStack(alignment:.leading){Text(district.0).bold();Text(district.1).font(.caption).foregroundStyle(.secondary)};Spacer();Image(systemName:"arrow.up.right").font(.caption) }.padding(.vertical,7) }
            case .settings: Text("FIELD SETTINGS").font(.headline); Text("Audio levels").foregroundStyle(.secondary); Slider(value:.constant(0.7)); Text("Camera sensitivity").foregroundStyle(.secondary); Slider(value:.constant(0.5)); Text("Landscape gameplay · Touch controls").font(.caption).foregroundStyle(.secondary)
            case .multiplayer: MultiplayerView()
            case .character: Text("DETECTIVE PROFILE").font(.headline); TextField("Character name",text:$game.playerName).textFieldStyle(.roundedBorder); Text("FIELD ATTIRE").font(.caption.bold()).tracking(2).foregroundStyle(.red); ForEach(["Greywood standard","Raincoat investigator","Night operations"],id:\.self) { Text("◉  \($0)").padding().frame(maxWidth:.infinity,alignment:.leading).background(.white.opacity(0.06),in:RoundedRectangle(cornerRadius:8)) }
            }
        }.padding() }.navigationTitle(title).toolbar { ToolbarItem(placement:.topBarTrailing) { Button("Close") { if game.inGame { game.panel=nil } else { game.panel=nil } } } } }
        .presentationBackground(Color(red:0.045,green:0.05,blue:0.06))
    }
    private var title:String { switch panel { case .cases:"Case Files"; case .notebook:"Investigation Notebook"; case .map:"Greywood Map"; case .settings:"Settings"; case .multiplayer:"Online"; case .character:"Detective" } }
}
