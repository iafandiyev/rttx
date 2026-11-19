#!/usr/bin/env bash
set -euo pipefail
test -f project.yml
test -f SHADOWFILES/App/ShadowFilesApp.swift
test -f Backend/Package.swift
test -f .github/workflows/ios.yml
if command -v xcodegen >/dev/null; then xcodegen generate; fi
if command -v swift >/dev/null; then (cd Backend && swift test); else echo "Swift unavailable; backend tests skipped"; fi
