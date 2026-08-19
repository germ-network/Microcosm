# @germ-network/microcosm

## 0.4.0

### Minor Changes

- [#21](https://github.com/germ-network/Microcosm/pull/21) [`e79a586`](https://github.com/germ-network/Microcosm/commit/e79a586a1f1085cd1aa0e80c2e6828e414da0124) Thanks [@germ-mark](https://github.com/germ-mark)! - `resolveMiniDoc`'s `Atproto.DIDDocument` adapter now publishes the `#atproto` verification method instead of an empty list. Slingshot returns `signing_key` on the wire and the adapter discarded it, so a repo proof checked against a Slingshot-resolved document failed for want of a key — nondeterministically, since `optimizedResolve` races this resolver against plc.directory and either can win. The method is spelled the way plc.directory spells it — fully-qualified `did:...#atproto` id, `Multikey`, self-controlled — so the two resolvers now agree field for field.

  Requires AtprotoTypes 0.5.1, where `VerificationMethod`'s initializer became public.

### Patch Changes

- [#19](https://github.com/germ-network/Microcosm/pull/19) [`5fddb86`](https://github.com/germ-network/Microcosm/commit/5fddb866f2b986c008ae89b2abd54dfe2c535d7a) Thanks [@germ-mark](https://github.com/germ-mark)! - Add Android CI, gating the one FoundationNetworking site.

  `Tests/MicrocosmTests/MicrocosmTests.swift` constructs `Slingshot.Resolver` with
  `URLSession.shared` directly — the only real usage in the package, since `Sources/`
  sweeps clean. Gated on `canImport`, so the Apple build is unchanged.

  Verified with a clean Android cross-build including the test target
  (`swift build --build-tests --swift-sdk aarch64-unknown-linux-android28`) — builds and
  links green from an empty `.build`.

## 0.3.3

### Patch Changes

- [#17](https://github.com/germ-network/Microcosm/pull/17) [`24bf366`](https://github.com/germ-network/Microcosm/commit/24bf366bcc8f9fc0c6769dd1e70bcc58fb7a9122) Thanks [@germ-mark](https://github.com/germ-mark)! - bump dependencies to consistent use of safe httpresponse init, narrow http imports"

## 0.3.2

### Patch Changes

- [#15](https://github.com/germ-network/Microcosm/pull/15) [`8c181f4`](https://github.com/germ-network/Microcosm/commit/8c181f47ba628dde660f8bc97b07899078f5fb06) Thanks [@germ-mark](https://github.com/germ-mark)! - adopt handle validation

## 0.3.1

### Patch Changes

- [#13](https://github.com/germ-network/Microcosm/pull/13) [`50d38f7`](https://github.com/germ-network/Microcosm/commit/50d38f75f4ce4d191a2d58f77820abb422939fd2) Thanks [@germ-mark](https://github.com/germ-mark)! - adopt atproto Types 0.4.0 refactor tranche

- [#12](https://github.com/germ-network/Microcosm/pull/12) [`7156417`](https://github.com/germ-network/Microcosm/commit/715641770fe03af2955b8613c5a1466b7c67ae0d) Thanks [@germ-mark](https://github.com/germ-mark)! - add a conversion of Minidoc to Atproto.DidDocument

## 0.3.0

### Minor Changes

- [#7](https://github.com/germ-network/Microcosm/pull/7) [`e40f420`](https://github.com/germ-network/Microcosm/commit/e40f4205485a2b8abdd3d0ab2b21371c7c4436ae) Thanks [@anna-germ](https://github.com/anna-germ)! - Update always-throwing Slingshot handle resolve to have optional return type (to satisfy Resolver protocol)

## 0.2.0

### Minor Changes

- [#8](https://github.com/germ-network/Microcosm/pull/8) [`d3669b8`](https://github.com/germ-network/Microcosm/commit/d3669b81e7b60fdf1d9e594040ee55a8a5e0469b) Thanks [@germ-mark](https://github.com/germ-mark)! - sync types with updated AtprotoTypes and AtprotoClient changes

## 0.1.0

### Minor Changes

- [#3](https://github.com/germ-network/Microcosm/pull/3) [`f79dd4a`](https://github.com/germ-network/Microcosm/commit/f79dd4affd7b56a188666b11f8a8750ba1b8dd2f) Thanks [@germ-mark](https://github.com/germ-mark)! - adopt upstream protocol definitions for xrpc
