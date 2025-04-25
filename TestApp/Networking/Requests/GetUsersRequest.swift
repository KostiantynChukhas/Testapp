import Foundation
import Alamofire

class GetUsersRequest: BaseRequest {
    
    private var count: Int
    private var page: Int
    
    init(count: Int, page: Int) {
        self.count = count
        self.page = page
    }
    
    override func apiPath() -> String? {
        return Defines.baseEndpoint + "/users"
    }
    
    override func parameters() -> [String : Any]? {
        return [ "count":count,
                 "page": page]
    }
    
    override func method() -> HTTPMethod {
        return .get
    }
    
    func perform() async throws -> RequestResultCodableAsync<UserModel> {
        return try await RequestManager.shared.performRequest(self, to: UserModel.self)
    }
}
