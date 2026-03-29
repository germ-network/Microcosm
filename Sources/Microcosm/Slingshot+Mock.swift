import AtprotoClient
import AtprotoTypes
import Foundation

extension Microcosm {
	public struct MockSlingshot: SlingshotInterface {
		public init() {}

		public func request<X>(
			_: X.Type,
			parameters: X.Parameters,
			service: URL?
		) async throws -> X.Output where X: XRPCRequest {
			.mock()
		}
	}
}
