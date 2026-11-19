import Foundation
struct Mission: Identifiable, Codable {
    var id: String; var title: String; var subtitle: String; var summary: String; var objectives: [String]; var progress: Int = 0
    static let catalog = [
        Mission(id:"empty-apartment",title:"The Empty Apartment",subtitle:"Old Town · Case 01",summary:"A tenant vanished without taking his coat or keys. The room was cleaned in haste.",objectives:["Search the apartment","Inspect the service key","Question the neighbor","Connect the delivery slip"]),
        Mission(id:"blood-on-docks",title:"Blood on the Docks",subtitle:"Industrial District · Case 02",summary:"A night guard was found in Warehouse 6. The dock ledger has gone missing.",objectives:["Examine the casing","Locate the weapon","Question dockworkers","Track the suspect"]),
        Mission(id:"last-witness",title:"The Last Witness",subtitle:"Greywood · Case 03",summary:"A witness disappeared hours before a corruption hearing.",objectives:["Search the rail depot","Find the witness phone","Follow the driver","Rescue the witness"])
    ]
}
