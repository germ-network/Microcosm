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

		public init(resourceFetcher: HTTPFetcher) {
			self.slingshot = .init(resourceFetcher: resourceFetcher)
		}
	}
}

extension Slingshot.Resolver: Atproto.Resolver {
	public func resolve(handle: Atproto.Handle) async throws -> Atproto.DID? {
		try await slingshot.resolveHandle(handle)
	}

	public func resolve(did: Atproto.DID) async throws -> Atproto.DIDDocument? {
		let miniDoc = try await slingshot.resolveMiniDoc(identifier: .did(did))

		guard let miniDoc else {
			return nil
		}

		guard miniDoc.did == did else {
			throw Slingshot.Errors.didMismatch
		}

		return miniDoc.didDocument
	}

	public func verifiedResolve(handle: Atproto.Handle) async throws -> Atproto.DIDDocument
		.Verified?
	{
		let miniDoc = try await slingshot.resolveMiniDoc(identifier: .handle(handle))

		guard let miniDoc else {
			return nil
		}

		return
			try miniDoc
			.didDocument
			.verified(expecting: handle, did: miniDoc.did)
	}
}
