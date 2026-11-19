import Vapor
func configure(_ app:Application) throws {
    app.http.server.configuration.hostname=Environment.get("HOST") ?? "0.0.0.0"
    app.http.server.configuration.port=Environment.get("PORT").flatMap(Int.init) ?? 8080
    app.get("health") { _ in ["status":"ok","service":"shadow-files","protocol":1] }
    app.webSocket("game") { req, ws in RoomManager.shared.connect(ws) }
}
