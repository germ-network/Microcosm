//
//  ProxySlingshot.swift
//  Microcosm
//
//  Created by Mark @ Germ on 4/28/26.
//

import AtprotoClient
import AtprotoTypes
import Foundation

//extend a proxyable ( a pds agent ) to call Slingshot
//https://slingshot.microcosm.blue/#description/service-proxying

extension Atproto.XRPC.ProxyCallable {
	func slingshotRequest<X: Atproto.XRPC.Request>(
		_: X.Type,
		parameters: X.Parameters,
	) async throws -> X.Output {
		let proxyHost = try Microcosm.Slingshot.defaultServiceURL
			.tryUnwrap
			.host(percentEncoded: true)
			.tryUnwrap(Microcosm.Errors.improperServiceUrl)

		return try await call(
			X.self,
			parameters: parameters,
			proxy: .init(
				did: .init(method: .web, identifier: proxyHost),
				endpoint: "slingshot"
			)
		)
	}
}
