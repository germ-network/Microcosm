//
//  MiniDocDocumentTests.swift
//  Microcosm
//
//  Created by Mark @ Germ on 8/19/26.
//

import AtprotoTypes
import AtprotoTypesVerify
import Foundation
import Microcosm
import MicrocosmMocks
import Testing

///The contract worth pinning is not that the field is populated but that the
///repo verifier accepts what it holds — `RepoSigningKey` matches on fragment,
///controller and multibase, and getting any one of the three wrong leaves the
///document as unusable as the empty list it replaced.
struct MiniDocDocumentTests {
	@Test("the miniDoc document publishes a signing key the repo verifier accepts")
	func carriesAtprotoSigningKey() throws {
		let miniDoc = try Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output.mock()
		let document = miniDoc.didDocument

		let key = try RepoSigningKey(atprotoKeyIn: document, did: miniDoc.did)
		#expect(key.curve == .secp256k1)
		#expect(key.compressedPoint.count == 33)
	}

	///`RepoSigningKey`'s matcher accepts a bare `#atproto` fragment too, so the
	///test above can't tell the fully-qualified form from that one — but
	///plc.directory always emits the fully-qualified form, and a consumer
	///racing this resolver against that one shouldn't see two documents that
	///differ in shape depending on which won.
	@Test("the published method matches plc.directory's shape, not just RepoSigningKey's matcher")
	func matchesPlcDirectoryShape() throws {
		let miniDoc = try Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output.mock()
		let method = try #require(miniDoc.didDocument.verificationMethod?.first)

		#expect(method.id == miniDoc.did.rawValue + "#atproto")
		#expect(method.type == "Multikey")
		#expect(method.controller == miniDoc.did.rawValue)
	}

	///Guards the rest of the literal: the PDS entry sits in the same
	///initializer the signing key was added to.
	@Test("populating the signing key leaves the PDS entry reachable")
	func stillResolvesPDS() throws {
		let miniDoc = try Lexicon.Blue.Microcosm.Identity.ResolveMiniDoc.Output.mock()
		#expect(try miniDoc.didDocument.pdsUrl == miniDoc.pds)
	}
}
