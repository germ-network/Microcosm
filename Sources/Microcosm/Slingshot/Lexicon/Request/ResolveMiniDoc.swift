import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience

import struct HTTPTypes.HTTPResponse

//https://slingshot.microcosm.blue/#tag/slingshot-specific-queries/GET/xrpc/blue.microcosm.identity.resolveMiniDoc
extension Lexicon.Blue.Microcosm.Identity {
	public enum ResolveMiniDoc: Atproto.XRPC.Request {
		public struct Id: Atproto.XRPC.EndpointId {
			public static var nsid: Atproto.NSID {
				.init(string: "blue.microcosm.identity.resolveMiniDoc")
			}

			public init() {}
		}
		public static var outputEncoding: HTTPContentType {
			.json
		}

		public struct Output: Sendable, Codable {
			public let did: Atproto.DID
			public let handle: Atproto.Handle
			public let pds: URL
			public let signingKey: String

			package init(
				did: Atproto.DID,
				handle: Atproto.Handle,
				pds: URL,
				signingKey: String
			) {
				self.did = did
				self.handle = handle
				self.pds = pds
				self.signingKey = signingKey
			}

			enum CodingKeys: String, CodingKey {
				case signingKey = "signing_key"
				case did
				case handle
				case pds
			}
		}

		public struct Parameters: QueryParametrizable {
			public let identifier: LexiconString.AtIdentifier

			public init(identifier: LexiconString.AtIdentifier) {
				self.identifier = identifier
			}

			public func asQueryItems() -> [URLQueryItem] {
				return [
					.init(name: "identifier", value: identifier.rawValue)
				]
			}
		}
	}
}

extension Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc: Atproto.XRPC.ResponseParsing {
	public static var badRequestErrors: Set<String> {
		[]  //not defined
	}

	public static var recognizedStatuses: Set<HTTPResponse.Status> {
		[.badRequest]
	}
}

extension Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output {
	///Slingshot returns the repo signing key on the wire, so the document it
	///backs can carry it rather than making a consumer re-resolve through
	///plc.directory for the one field a repo proof needs.
	public var didDocument: Atproto.DIDDocument {
		.init(
			context: [],
			id: did.rawValue,
			alsoKnownAs: ["at://" + handle.rawValue],
			//spelled the way plc.directory spells it — fully-qualified id,
			//`Multikey`, self-controlled — because `optimizedResolve` races
			//this resolver against that one, and a consumer holding the result
			//should not be able to tell which won.
			verificationMethod: [
				.init(
					id: did.rawValue + "#atproto",
					type: "Multikey",
					controller: did.rawValue,
					publicKeyMultibase: signingKey
				)
			],
			service: [
				.init(
					id: "#atproto_pds",
					type: "AtprotoPersonalDataServer",
					serviceEndpoint: pds
				)
			]
		)
	}
}
