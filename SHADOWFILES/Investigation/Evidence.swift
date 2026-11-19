import Foundation
import simd
struct Evidence: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var detail: String
    var kind: String
    var position: SIMD3<Float>
    var suspects: [String]
    var caseID: String
    var status: String { "Collected" }
    static let city: [Evidence] = [
        .init(id:"apt-key",title:"Scuffed brass key",detail:"A service key with fresh grey paint on the teeth. The property manager uses this cut.",kind:"Physical",position:[8,0,-9],suspects:["Mara Voss"],caseID:"empty-apartment"),
        .init(id:"apt-note",title:"Torn delivery slip",detail:"A warehouse delivery was redirected to Pier 14 at 02:10.",kind:"Document",position:[-8,0,12],suspects:["Elias Rook"],caseID:"empty-apartment"),
        .init(id:"dock-shell",title:"9 mm casing",detail:"The casing is warm to the touch in the memory of the scene. One shot, close range.",kind:"Ballistics",position:[27,0,-22],suspects:["Elias Rook"],caseID:"blood-on-docks"),
        .init(id:"dock-gun",title:"Unregistered pistol",detail:"Serial number filed away. A trace of blue marine enamel remains under the grip.",kind:"Weapon",position:[34,0,-15],suspects:["Elias Rook"],caseID:"blood-on-docks"),
        .init(id:"witness-phone",title:"Cracked phone",detail:"Last outgoing call placed near the old rail depot.",kind:"Digital",position:[-31,0,-28],suspects:["Unknown driver"],caseID:"last-witness")
    ]
}
