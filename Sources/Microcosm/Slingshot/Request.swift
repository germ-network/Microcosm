import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience
import HTTPTypes

extension Microcosm.Slingshot {
	/// - Parameter service: URL?
	/// - Returns: (serviceUrl: URL, proxy: String?)
	private func getServiceUrl(service: URL?) throws -> (URL, ProxyService?) {
		let defaultService = try Microcosm.Slingshot.defaultServiceURL.tryUnwrap

		guard let service else {
			// Using the default service:
			return (defaultService, nil)
		}

		// Using service proxying:
		let url = try URL(string: "/", relativeTo: service)
			.tryUnwrap(Microcosm.Errors.improperServiceUrl)

		let proxyHost = try defaultService.host(percentEncoded: true)
			.tryUnwrap(Microcosm.Errors.improperServiceUrl)

		return (
			url,
			.init(
				did: .init(method: .web, identifier: proxyHost),
				endpoint: "slingshot"
			)
		)
	}

	public func request<X: XRPCRequest>(
		_ xrpc: X.Type,
		parameters: X.Parameters,
		service: URL?,
	) async throws -> X.Output {
		let (serviceUrl, proxy) = try getServiceUrl(service: service)
		let requestURL =
			serviceUrl
			.appending(path: "/xrpc/" + X.nsid)
			.appending(queryItems: parameters.asQueryItems())

		var headers = HTTPFields(
			dictionaryLiteral: (.accept, HTTPContentType.json.rawValue)
		)

		if let proxy {
			headers[try .atprotoProxy.tryUnwrap] = proxy.headerValue
		}

		let request = BundledHTTPRequest(
			request: .init(method: .get, url: requestURL, headerFields: headers)
		)

		return try await resourceFetcher.data(for: request)
			.parse(X.self)
	}
}
