import SwiftUI
struct MainMenuView: View {
    @EnvironmentObject private var game: GameManager
    var body: some View {
        ZStack { LinearGradient(colors:[Color(red:0.035,green:0.045,blue:0.055),.black],startPoint:.topLeading,endPoint:.bottomTrailing).ignoresSafeArea(); HStack(spacing:0) {
            VStack(alignment:.leading,spacing:24) { HStack(spacing:10) { Image(systemName:"eye.slash.fill").foregroundStyle(.red); Text("SHADOW\nFILES").font(.system(size:34,weight:.black,design:.rounded)).tracking(4).lineSpacing(-5) }; Rectangle().fill(.red).frame(width:80,height:2); Text("GREYWOOD · 2032").font(.caption.bold()).tracking(3).foregroundStyle(.white.opacity(0.5)); Text("The truth leaves a trace.").font(.title3).italic().foregroundStyle(.white.opacity(0.8)); Spacer(); Text("FIELD OPERATIONS").font(.caption2.bold()).tracking(2).foregroundStyle(.red.opacity(0.85)) }.padding(32).frame(maxWidth:.infinity,alignment:.leading)
            VStack(spacing:10) { menuButton("CONTINUE",icon:"play.fill"){ game.start(Mission.catalog.first!) }; menuButton("PLAY CASE",icon:"folder.fill"){ game.panel = .cases }; menuButton("MULTIPLAYER",icon:"person.2.fill"){ game.panel = .multiplayer }; menuButton("CHARACTER",icon:"person.crop.square"){ game.panel = .character }; menuButton("SETTINGS",icon:"slider.horizontal.3"){ game.panel = .settings }; Spacer(); Text("AN ORIGINAL GREYWOOD POLICE STORY").font(.system(size:9,weight:.semibold)).tracking(1.5).foregroundStyle(.white.opacity(0.35)) }.frame(width:280).padding(.vertical,36).padding(.trailing,38)
        } }
        .sheet(item:$game.panel) { p in GamePanelView(panel:p).environmentObject(game) }
    }
    private func menuButton(_ label:String,icon:String,action:@escaping()->Void)->some View { Button(action:action) { HStack { Image(systemName:icon).frame(width:24); Text(label).tracking(1.6); Spacer(); Image(systemName:"arrow.up.right").font(.caption) }.font(.system(size:13,weight:.bold)).padding(16).frame(maxWidth:.infinity).background(.white.opacity(label == "CONTINUE" ? 0.12 : 0.045),in:RoundedRectangle(cornerRadius:8)).overlay(RoundedRectangle(cornerRadius:8).stroke(.white.opacity(0.1),lineWidth:1)) } }
}
