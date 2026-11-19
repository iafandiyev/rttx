# SHADOW FILES

Native SwiftUI + RealityKit detective game prototype for iPhone, set in GREYWOOD (2032). Includes a generated compact city, touch movement, camera control, three original case files, nearby evidence collection, a case notebook, local evidence saves, and an optional WebSocket co-op starter.

## Build iOS

On macOS install Xcode and XcodeGen, then run `xcodegen generate` and build the `SHADOWFILES` scheme. GitHub Actions builds an unsigned device app and packages `SHADOWFILES-unsigned.ipa` as a workflow artifact. Unsigned IPAs are for sideloading workflows and are not installable through the normal App Store flow without signing.

## Controls

Landscape touch play: left joystick to move, drag the right side to orbit the camera, tap Sprint and Inspect. The red evidence markers identify scene clues. Notebook tracks found evidence and case objectives. The other panels expose cases, district map, detective presets, and co-op connection settings.

## Server

See [Backend/README.md](Backend/README.md). Offline case play needs no server. Server URL defaults to `ws://127.0.0.1:8080/game` and can be changed in the online panel.

## Scope

This repository is an executable vertical-slice foundation, not a finished AAA production. It uses procedural low-poly architectural geometry and a stylized capsule detective; facial assets, authored animation, drivable vehicles, full dialogue, server-authoritative mission completion, SQLite account persistence, and original audio are not yet implemented. There is no Apple toolchain on the authoring host; CI performs the iOS build on macOS.
