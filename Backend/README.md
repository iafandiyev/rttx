# SHADOW FILES multiplayer server

Requires Swift 5.9+ and a network connection to resolve Vapor for the first build. `swift run` starts the server on `0.0.0.0:8080`. `PORT` and `HOST` configure binding; `/health` reports status and `/game` accepts WebSockets. A free local server is sufficient for development; deploy independently on any Swift/Vapor host or use the included Dockerfile.

Protocol uses JSON objects `{ "type": "...", "sequence": 1, "payload": {} }`. Supported messages are `authenticate`, `create_room`, `join_room` (payload `code`), `leave_room`, `player_state` (finite bounded x/y/z), and `ping`. Room codes are six characters and capacity is eight. Input size is limited to 4096 bytes and player state updates are rate-limited to 40/s. The server assigns UUIDs and relays player positions. Clients must treat case completion as local-only until validated server mission rules are added.

The initial room service is in-memory. SQLite environment documentation is reserved for persistence work; this starter currently does not persist accounts, rooms, or evidence. Do not expose it to untrusted public traffic without TLS termination, authentication tokens, durable session storage, and server-side mission rules.
