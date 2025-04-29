import Foundation
import Alamofire

class CreateNewUsersRequest: BaseRequest {
    
    private var model: SignUpSectionsModel
    private var token: String
    
    init(model: SignUpSectionsModel, token: String) {
        self.model = model
        self.token = token
    }
    
    override func apiPath() -> String? {
        return Defines.baseEndpoint + "/users"
    }
    
    override func headers() -> [String : String]? {
        return [
            "accept": "application/json;charset=UTF-8",
            "Token": token
        ]
    }
    
    override func parameters() -> [String : Any]? {
        return [ "name":model.nameValue ?? "",
                 "email": model.emailValue ?? "",
                 "phone":model.phoneValue ?? "",
                 "position_id": model.radioValue ?? ""]
    }
    
    override func method() -> HTTPMethod {
        return .post
    }
    
    func perform() async throws -> RequestResultCodableAsync<CreateUserModel> {
        var files: [(data: Data, name: String, fileName: String, mimeType: String)] = []
        if let imageData = model.imageValue?.0, !imageData.isEmpty {
            files.append((data: imageData, name: "photo", fileName: "image.jpg", mimeType: "image/jpeg"))
        }
        return try await RequestManager.shared.performMultipartRequest(self, to: CreateUserModel.self, files: files)
    }

}
