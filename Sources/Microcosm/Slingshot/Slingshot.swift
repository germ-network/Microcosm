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
		func request<X: Atproto.XRPC.Request>(
			_: X.Type,
			parameters: X.Parameters,
		) async throws -> X.Output

		func resolveHandle(_: Atproto.Handle) async throws -> Atproto.DID?
		func resolveMiniDoc(identifier: LexiconString.AtIdentifier) async throws
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

extension Microcosm.Slingshot: Atproto.XRPC.Callable {
	public func response(
		_ requestComponents: XRPCRequestComponents
	) async throws -> HTTPDataResponse {
		let defaultService = try Self.defaultServiceURL.tryUnwrap
		let request =
			try requestComponents
			.constructUrl(serviceUrl: defaultService)
		return try await resourceFetcher.data(for: request)
	}

}

extension Microcosm.Slingshot: Microcosm.SlingshotInterface {
	public func request<X>(
		_: X.Type,
		parameters: X.Parameters
	) async throws -> X.Output where X: AtprotoTypes.Atproto.XRPC.Request {
		try await call(X.self, parameters: parameters)
	}
}

extension Microcosm.SlingshotInterface {
	public func resolveHandle(_ handle: Atproto.Handle) async throws -> AtprotoTypes.Atproto.DID? {
		throw Microcosm.Errors.notImplemented
	}

	public func resolveMiniDoc(identifier: LexiconString.AtIdentifier)
		async throws
		-> Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output?
	{
		do {
			return try await request(
				Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.self,
				parameters: .init(identifier: identifier),
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
