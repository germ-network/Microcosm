import AtprotoTypes
import Foundation
import Microcosm
import Testing

struct OnlineTests {
	let handle: Atproto.Handle
	let did: Atproto.DID

	let resolver: Atproto.Resolver

	init() throws {
		handle = try .init(string: "germnetwork.com")
		did = try .init(string: "did:plc:4yvwfwxfz5sney4twepuzdu7")
		resolver = Slingshot.Resolver(resourceFetcher: URLSession.shared)
	}

	@Test func functionalResolverTests() async throws {
		let resolvedDid = try await resolver.resolve(handle: handle)
		#expect(resolvedDid == did)

		let _ = try await resolver.resolve(did: did)

		let _ = try await resolver.verifiedResolve(handle: handle)

		//composite methods
		let _ = try await resolver.verifiedResolve(atIdentifier: .did(did))
	}
}
