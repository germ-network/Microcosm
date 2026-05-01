//
//  Slingshot+Resolver.swift
//  Microcosm
//
//  Created by Mark @ Germ on 5/1/26.
//

import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience

///a struct wrapping a Slingshot object that hides the Slingshot API and conforms to Atproto.Resolver

extension Slingshot {
	public struct Resolver {
		let slingshot: Slingshot

		init(resourceFetcher: HTTPFetcher) {
			self.slingshot = .init(resourceFetcher: resourceFetcher)
		}
	}
}

extension Slingshot.Resolver: Atproto.Resolver {
	public func resolve(handle: Atproto.Handle) async throws -> Atproto.DID? {
		try await slingshot.resolveHandle(handle)
	}

	public func resolve(did: Atproto.DID) async throws -> Atproto.DIDDocument? {
		try await slingshot.resolveMiniDoc(identifier: .did(did))?
			.didDocument
	}

	public func verifiedResolve(handle: Atproto.Handle) async throws -> Atproto.DIDDocument
		.Verified?
	{
		try await slingshot.resolveMiniDoc(identifier: .handle(handle))?
			.didDocument
			.verified(expecting: handle)
	}
}
