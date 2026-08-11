---
"@germ-network/microcosm": patch
---

Add Android CI, gating the one FoundationNetworking site.

`Tests/MicrocosmTests/MicrocosmTests.swift` constructs `Slingshot.Resolver` with
`URLSession.shared` directly — the only real usage in the package, since `Sources/`
sweeps clean. Gated on `canImport`, so the Apple build is unchanged.

Verified with a clean Android cross-build including the test target
(`swift build --build-tests --swift-sdk aarch64-unknown-linux-android28`) — builds and
links green from an empty `.build`.
