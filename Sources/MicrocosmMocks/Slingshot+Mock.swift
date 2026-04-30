import AtprotoClient
import AtprotoTypes
import AtprotoTypesMocks
import Foundation
import Microcosm
import Mockable

extension Slingshot {
	public struct Mock: Interface {
		public init() {}

		public func request<X>(
			_: X.Type,
			parameters: X.Parameters
		) async throws -> X.Output where X: Atproto.XRPC.Request {
			if let mockableType = X.self as? Mockable.Type {
				return try (mockableType.mock() as? X.Output).tryUnwrap
			}
			throw MicrocosmErrors.notImplemented
		}
	}
}

extension Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output: Mockable {
	public static func mock() throws -> Self {
		.init(
			did: Atproto.DID.mock(),
			handle: try .init(string: "user.example.com"),
			pds: URL(string: "https://blusher.us-east.host.bsky.network")!,
			signingKey: "zQ3shPrWRUXva2mWziWZtffrjuXUx3E28WfgsAwStMcAmDt93"
		)
	}
}
