import Foundation
import Alamofire

class CreateNewUsersRequest: BaseRequest {
    
    private var model: SignUpSectionsModel
    
    init(model: SignUpSectionsModel) {
        self.model = model
    }
    
    override func apiPath() -> String? {
        return Defines.baseEndpoint + "/users"
    }
    
    override func headers() -> [String : String]? {
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers: [String : String]? = [
            "Content-type": "application/json;charset=UTF-8",
            "mimeType": "multipart/form-data; charset=utf-8",
            "Content-Type": "multipart/form-data; charset=utf-8; boundary=\(boundary)",
            "Token": "eyJpdiI6Im9mV1NTMlFZQTlJeWlLQ3liVks1MGc9PSIsInZhbHVlIjoiRTJBbUR4dHp1dWJ3ekQ4bG85WVZya3ZpRGlMQ0g5ZHk4M"
        ]
        
        return headers
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
        let files = [(data: model.imageValue?.0 ?? Data(), name: "FILE", fileName: "image.jpg", mimeType: "image/jpeg")]
        return try await RequestManager.shared.performMultipartRequest(self, to: CreateUserModel.self, files: files)
    }
}
