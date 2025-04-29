import Foundation
import Alamofire

class GetTokenRequest: BaseRequest {
    
    override func apiPath() -> String? {
        return Defines.baseEndpoint + "/token"
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform() async throws -> RequestResultCodableAsync<TokenModel> {
        return try await RequestManager.shared.performRequest(self, to: TokenModel.self)
    }
}
