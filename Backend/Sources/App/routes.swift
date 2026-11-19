import Vapor
struct HealthResponse: Content {
    let status: String
    let service: String
    let version: Int
}

func configure(_ app:Application) throws {
    app.http.server.configuration.hostname=Environment.get("HOST") ?? "0.0.0.0"
    app.http.server.configuration.port=Environment.get("PORT").flatMap(Int.init) ?? 8080
    app.get("health") { _ in HealthResponse(status:"ok",service:"shadow-files",version:1) }
    app.webSocket("game") { req, ws in RoomManager.shared.connect(ws) }
}
