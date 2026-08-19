---
"@germ-network/microcosm": minor
---

`resolveMiniDoc`'s `Atproto.DIDDocument` adapter now publishes the `#atproto` verification method instead of an empty list. Slingshot returns `signing_key` on the wire and the adapter discarded it, so a repo proof checked against a Slingshot-resolved document failed for want of a key — nondeterministically, since `optimizedResolve` races this resolver against plc.directory and either can win. The method is spelled the way plc.directory spells it — fully-qualified `did:...#atproto` id, `Multikey`, self-controlled — so the two resolvers now agree field for field.

Requires AtprotoTypes 0.5.1, where `VerificationMethod`'s initializer became public.
