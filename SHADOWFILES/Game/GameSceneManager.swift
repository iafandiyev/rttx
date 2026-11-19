import RealityKit
import SwiftUI
import Combine
import UIKit

@MainActor final class GameSceneManager {
    private weak var game: GameManager?
    private let player = Entity()
    private let camera = PerspectiveCamera()
    private var evidenceEntities: [(Entity,Evidence)] = []
    private var buildingBounds: [(Float,Float,Float,Float)] = []
    private var timer: Cancellable?
    private var lastLook = SIMD2<Float>(repeating: 0)
    private var yaw: Float = 0
    private var pitch: Float = -0.2
    func build(into content: RealityViewContent, evidence: [Evidence], game: GameManager) {
        self.game = game
        let root = Entity(); root.name = "Greywood"
        var groundMat = PhysicallyBasedMaterial(); groundMat.baseColor = .init(tint: UIColor(red:0.12,green:0.14,blue:0.15,alpha:1)); groundMat.roughness = .init(floatLiteral:0.34)
        let ground = ModelEntity(mesh:.generatePlane(width:180,depth:180),materials:[groundMat]); ground.position.y = -0.12; root.addChild(ground)
        buildCity(root)
        let body = ModelEntity(mesh:.generateCapsule(height:1.75,diameter:0.62),materials:[SimpleMaterial(color:UIColor(red:0.14,green:0.16,blue:0.18,alpha:1),roughness:0.8,isMetallic:false)])
        body.position.y = 0.9; player.addChild(body); player.position = [0,0,0]; root.addChild(player)
        camera.position = [0,2.4,5.6]; camera.look(at:[0,1.1,0],from:camera.position,relativeTo:nil); root.addChild(camera)
        let sun = DirectionalLight(); sun.light.intensity = 650; sun.light.color = .init(white:0.70,alpha:1); sun.shadow = .init(); sun.orientation = simd_quatf(angle:-0.9,axis:[1,0,0]); root.addChild(sun)
        let ambient = PointLight(); ambient.light.intensity = 280; ambient.light.attenuationRadius = 75; ambient.position = [0,18,0]; root.addChild(ambient)
        for (index,e) in evidence.enumerated() { let marker = ModelEntity(mesh:.generateSphere(radius:0.28),materials:[SimpleMaterial(color:.systemRed,roughness:0.22,isMetallic:true)]); marker.position = e.position + [0,0.45,0]; marker.name = e.id; root.addChild(marker); evidenceEntities.append((marker,e)); _ = index }
        content.add(root)
        timer = Timer.publish(every:0.016,on:.main,in:.common).autoconnect().sink { [weak self] _ in self?.tick() }
    }
    private func buildCity(_ root:Entity) {
        let blocks:[(Float,Float,Float,Float,UIColor)] = [(-17,-12,10,22,.init(white:0.22,alpha:1)),(-2,-15,11,15,.init(white:0.30,alpha:1)),(16,-11,12,24,.init(white:0.20,alpha:1)),(-18,14,12,18,.init(white:0.32,alpha:1)),(1,15,10,20,.init(white:0.23,alpha:1)),(19,17,13,16,.init(white:0.29,alpha:1)),(-31,-30,13,12,.init(white:0.25,alpha:1)),(31,-28,16,15,.init(white:0.28,alpha:1)),(-34,30,15,13,.init(white:0.21,alpha:1)),(33,32,13,14,.init(white:0.3,alpha:1))]
        for (x,z,w,h,color) in blocks { buildingBounds.append((x,z,w/2+0.55,w*0.39+0.55)); var m=PhysicallyBasedMaterial(); m.baseColor = .init(tint:color); m.roughness = .init(floatLiteral:0.76); let building=ModelEntity(mesh:.generateBox(size:[w,h,w*0.78]),materials:[m]); building.position=[x,h/2,z]; building.components.set(CollisionComponent(shapes:[.generateBox(size:[w,h,w*0.78])])); root.addChild(building)
            for floor in stride(from:1, to:Int(h)-1, by:3) { let window=ModelEntity(mesh:.generateBox(size:[w*0.78,0.12,0.04]),materials:[SimpleMaterial(color:UIColor(red:0.66,green:0.49,blue:0.29,alpha:0.75),isMetallic:true)]); window.position=[x,Float(floor),z-w*0.39-0.03]; root.addChild(window) }
        }
        // Raised sidewalks, cross streets, and pools of street light create distinct compact districts.
        for z in stride(from:-70,to:71,by:28) { let road=ModelEntity(mesh:.generateBox(size:[9,0.03,180]),materials:[SimpleMaterial(color:UIColor(white:0.055,alpha:1),roughness:0.2,isMetallic:false)]); road.position=[0,0,z]; root.addChild(road) }
        for x in stride(from:-70,to:71,by:28) { let road=ModelEntity(mesh:.generateBox(size:[180,0.03,9]),materials:[SimpleMaterial(color:UIColor(white:0.055,alpha:1),roughness:0.2,isMetallic:false)]); road.position=[x,0,0]; root.addChild(road) }
    }
    func look(delta:SIMD2<Float>) { lastLook=delta }
    func endLook() { yaw -= lastLook.x * 0.0025; pitch = max(-0.75,min(0.2,pitch-lastLook.y*0.0015)); lastLook = .zero }
    private func tick() {
        guard let game else { return }
        let speed:Float = game.sprinting ? 0.12 : 0.065
        let dx = game.move.x*speed, dz = game.move.y*speed
        if abs(dx)+abs(dz)>0.002 { let forward=SIMD3<Float>(sin(yaw),0,-cos(yaw)); let right=SIMD3<Float>(cos(yaw),0,sin(yaw)); let proposed=player.position + right*dx + forward*dz; let blocked=buildingBounds.contains { abs(proposed.x-$0.0)<$0.2 && abs(proposed.z-$0.1)<$0.3 }; if !blocked { player.position=proposed }; player.position.x=max(-GameConfiguration.worldRadius,min(GameConfiguration.worldRadius,player.position.x)); player.position.z=max(-GameConfiguration.worldRadius,min(GameConfiguration.worldRadius,player.position.z)) }
        let offset=SIMD3<Float>(-sin(yaw)*5,2.4+pitch,cos(yaw)*5); camera.position=player.position+offset; camera.look(at:player.position+[0,1,0],from:camera.position,relativeTo:nil)
        let candidate=evidenceEntities.min { simd_distance($0.0.position,player.position)<simd_distance($1.0.position,player.position) }
        game.nearbyEvidence = candidate.flatMap { simd_distance($0.0.position,player.position)<GameConfiguration.interactionDistance ? $0.1 : nil }
    }
}
