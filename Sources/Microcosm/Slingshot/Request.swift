import AtprotoClient
import AtprotoTypes
import Foundation
import GermConvenience
import HTTPTypes

extension Microcosm.Slingshot {
	/// - Parameter service: URL?
	/// - Returns: (serviceUrl: URL, proxy: String?)
	private func getServiceUrl(service: URL?) throws -> (URL, String?) {
		let defaultService = try Microcosm.Slingshot.defaultServiceURL.tryUnwrap

		guard let service else {
			// Using the default service:
			return (defaultService, nil)
		}

		// Using service proxying:
		guard let url = URL(string: "/", relativeTo: service) else {
			throw Microcosm.Errors.improperServiceUrl
		}

		guard let proxyHost = defaultService.host(percentEncoded: true) else {
			throw Microcosm.Errors.improperServiceUrl
		}

		return (url, "did:web:\(proxyHost)#slingshot")
	}

	public func request<X: XRPCRequest>(
		_ xrpc: X.Type,
		parameters: X.Parameters,
		service: URL?,
	) async throws -> X.Result {
		let (serviceUrl, proxy) = try getServiceUrl(service: service)
		let requestURL =
			serviceUrl
			.appending(path: "/xrpc/" + X.nsid)
			.appending(queryItems: parameters.asQueryItems())

		let customHeaders: [HTTPField] = try {
			if let proxy {
				[.init(name: try .atprotoProxy.tryUnwrap, value: proxy)]
			} else {
				[]
			}
		}()

		let request = HTTPRequestBody(
			url: requestURL,
			method: .get,
			customHeaders: customHeaders
		)

		let result = try await resourceFetcher.data(for: request)
			.success(
				decodeResult: X.Result.self,
				orError: Lexicon.XRPCError.self
			)

		switch result {
		case .error(let errorStruct, let responseStatus):
			throw Microcosm.Errors.requestFailed(
				responseStatus: responseStatus,
				error: errorStruct.error
			)
		case .result(let result):
			return result
		}
	}
}
