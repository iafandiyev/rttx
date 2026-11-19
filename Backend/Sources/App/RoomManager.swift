import Vapor
import Foundation
final class RoomManager {
    static let shared=RoomManager()
    private let lock=NSLock()
    private var rooms:[String:[UUID:WebSocket]]=[:]
    private var lastMessage:[ObjectIdentifier:Date]=[:]
    func connect(_ ws:WebSocket) {
        let id=UUID(); var roomCode:String?
        ws.onText { [weak self] socket,text in
            guard text.utf8.count < 4096, let data=text.data(using:.utf8), let msg=try? JSONSerialization.jsonObject(with:data) as? [String:Any], let type=msg["type"] as? String else { socket.close(code:.policyViolation); return }
            self?.lock.lock(); defer { self?.lock.unlock() }
            let now=Date(); let key=ObjectIdentifier(socket)
            if let previous=self?.lastMessage[key], now.timeIntervalSince(previous)<0.025 { return }; self?.lastMessage[key]=now
            let payload=msg["payload"] as? [String:String] ?? [:]
            switch type {
            case "authenticate": socket.send("{\"type\":\"authenticated\",\"player_id\":\"\(id)\"}")
            case "create_room":
                guard roomCode == nil else { return }; let code=String(UUID().uuidString.prefix(6)); roomCode=code; self?.rooms[code]=[id:socket]; socket.send("{\"type\":\"room_created\",\"code\":\"\(code)\"}")
            case "join_room":
                guard let code=payload["code"], var room=self?.rooms[code], room.count<8 else { socket.send("{\"type\":\"server_error\",\"message\":\"room unavailable\"}"); return }; room[id]=socket; self?.rooms[code]=room; roomCode=code; Self.broadcast(room,"{\"type\":\"player_joined\",\"player_id\":\"\(id)\"}")
            case "player_state":
                guard let x=Double(payload["x"] ?? "nan"),let y=Double(payload["y"] ?? "nan"),let z=Double(payload["z"] ?? "nan"),[x,y,z].allSatisfy({$0.isFinite && abs($0)<1000}),let code=roomCode,let room=self?.rooms[code] else { return }; Self.broadcast(room,"{\"type\":\"player_state\",\"player_id\":\"\(id)\",\"x\":\(x),\"y\":\(y),\"z\":\(z)}",excluding:id)
            case "ping": socket.send("{\"type\":\"pong\"}")
            case "leave_room": self?.rooms[roomCode ?? ""]?.removeValue(forKey:id); roomCode=nil
            default: socket.send("{\"type\":\"server_error\",\"message\":\"unsupported message\"}")
            }
        }
        ws.onClose.whenComplete { [weak self] _ in guard let self else{return}; self.lock.lock(); defer { self.lock.unlock() }; if let code=roomCode,let room=self.rooms[code] { room.values.forEach{$0.send("{\"type\":\"player_left\",\"player_id\":\"\(id)\"}")}; self.rooms[code]?.removeValue(forKey:id); if self.rooms[code]?.isEmpty == true { self.rooms.removeValue(forKey:code) } }; self.lastMessage.removeValue(forKey:ObjectIdentifier(ws)) }
    }
    private static func broadcast(_ room:[UUID:WebSocket],_ text:String,excluding:UUID?=nil) { for (id,socket) in room where id != excluding { socket.send(text) } }
}
