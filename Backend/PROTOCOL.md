# WebSocket protocol v1

Connect to `ws://host:8080/game` (use `wss` behind a TLS proxy in deployed environments). Frames are UTF-8 JSON objects with `type`, optional monotonically increasing client `sequence`, and a `payload` object. The server caps text frames at 4096 bytes and throttles accepted messages per connection.

| Client message | Payload | Server response |
| --- | --- | --- |
| `authenticate` | `player_id`, `display_name` | `authenticated` with server UUID |
| `create_room` | empty | `room_created` with six-character code |
| `join_room` | `code` | `player_joined` broadcast or `server_error` |
| `player_state` | finite bounded `x`, `y`, `z` | position broadcast with server player UUID |
| `leave_room` | empty | removes the room membership |
| `ping` | empty | `pong` |

Room capacity is eight. The current backend is a development relay: authentication is an anonymous session, room and player state are memory-only, and there is no durable mission authority. Do not treat client evidence or completion as server-verified. Accounts, friend invitations, team management, SQLite migrations, and durable progress are not in this initial vertical slice.
