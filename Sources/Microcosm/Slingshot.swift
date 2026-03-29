//
//  Slingshot.swift
//  Microcosm
//
//  Created by Mark @ Germ on 2/20/26.
//

import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience

extension Microcosm {
	public protocol SlingshotInterface: Sendable {
		func request<X: XRPCRequest>(
			_: X.Type,
			parameters: X.Parameters,
			service: URL?,
		) async throws -> X.Output

		func resolveHandle(handle: String) async throws -> Atproto.DID
		func resolveMiniDoc(identifier: String) async throws
			-> Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output?
		func resolveMiniDoc(identifier: String, serviceUrl: URL?) async throws
			-> Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output?
	}
}

extension Microcosm {
	public struct Slingshot {
		public static let defaultServiceURL = URL(
			string: "https://slingshot.microcosm.blue")

		let resourceFetcher: HTTPFetcher

		public init(resourceFetcher: HTTPFetcher) {
			self.resourceFetcher = resourceFetcher
		}
	}
}

extension Microcosm.Slingshot: Microcosm.SlingshotInterface {}

extension Microcosm.SlingshotInterface {
	// This feels like it should be in AtIdentifier as a static method?
	private func fromIdentifier(_ identifier: String) throws -> AtIdentifier {
		if identifier.starts(with: "did") {
			.did( try .init(string: identifier) )
		} else {
			.handle(identifier)
		}
	}

	public func resolveHandle(handle: String) async throws -> AtprotoTypes.Atproto.DID {
		throw Microcosm.Errors.notImplemented
	}

	public func resolveMiniDoc(identifier: String) async throws -> Lexicon.Blue.Microcosm
		.Identity.ResolveMiniDoc.Output?
	{
		try await resolveMiniDoc(identifier: identifier, serviceUrl: nil)
	}

	public func resolveMiniDoc(identifier: String, serviceUrl: URL?)
		async throws
		-> Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output?
	{
		let id = try fromIdentifier(identifier)

		do {
			return try await request(
				Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.self,
				parameters: Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc
					.Parameters(identifier: id),
				service: serviceUrl,
			)
		} catch Microcosm.Errors.requestFailed(400, let error) {
			if error == "RecordNotFound" {
				return nil
			} else {
				throw Microcosm.Errors.requestFailed(
					responseStatus: .badRequest, error: error)
			}
		}
	}
}
