import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience
import HTTPTypes

//https://slingshot.microcosm.blue/#tag/slingshot-specific-queries/GET/xrpc/blue.microcosm.identity.resolveMiniDoc
extension Lexicon.Blue.Microcosm.Identity {
	public enum ResolveMiniDoc: XRPCRequest {
		public static var acceptValue: HTTPContentType { .json }

		public static var nsid: Atproto.NSID { "blue.microcosm.identity.resolveMiniDoc" }

		public struct Output: Sendable, Codable {
			public let did: Atproto.DID
			public let handle: AtIdentifier.Handle
			public let pds: URL
			public let signingKey: String

			enum CodingKeys: String, CodingKey {
				case signingKey = "signing_key"
				case did
				case handle
				case pds
			}
		}

		public struct Parameters: QueryParametrizable {
			public let identifier: AtIdentifier

			public init(identifier: AtIdentifier) {
				self.identifier = identifier
			}

			public func asQueryItems() -> [URLQueryItem] {
				return [
					.init(name: "identifier", value: identifier.wireFormat)
				]
			}
		}
	}
}

extension Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc: XRPCResponseParsing {
	public static var badRequestErrors: Set<String> {
		[]  //not defined
	}

	public static var recognizedStatuses: Set<HTTPResponse.Status> {
		[.badRequest]
	}
}

extension Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output: Mockable {
	public static func mock() -> Self {
		.init(
			did: Atproto.DID.mock(),
			handle: "germnetwork.com",
			pds: URL(string: "https://blusher.us-east.host.bsky.network")!,
			signingKey: "zQ3shPrWRUXva2mWziWZt1vrjuXUx3E28WfgsAwStMcAmDt93"
		)
	}
}
