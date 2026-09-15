---
"@germ-network/microcosm": patch
---

Fix build against GermConvenience 0.8.0, which split `HTTPFetcher` and
`HTTPDataResponse` out of the base `GermConvenience` library into a new
`GermConvenienceHTTP` product. Adds the `GermConvenienceHTTP` product
dependency and the matching import, and raises the floor to `from: "0.8.0"`.

No public API change — this only restores buildability against current
GermConvenience releases.
