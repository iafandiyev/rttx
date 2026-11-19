#!/usr/bin/env bash
set -euo pipefail
command -v xcodegen >/dev/null || { echo "Install XcodeGen: brew install xcodegen" >&2; exit 1; }
xcodegen generate
xcodebuild -project SHADOWFILES.xcodeproj -scheme SHADOWFILES -configuration Release -sdk iphoneos -derivedDataPath build CODE_SIGNING_ALLOWED=NO
mkdir -p Payload
cp -R build/Build/Products/Release-iphoneos/SHADOWFILES.app Payload/
/usr/bin/zip -qry SHADOWFILES-unsigned.ipa Payload
