import UIKit
import Alamofire

protocol BaseRequestProtocol {
    
    func method() -> HTTPMethod
    func apiPath() -> String?
    func headers() -> [String : String]?
    func parameters() -> [String : Any]?
    func rawData() -> Data?
    func encoding() -> ParameterEncoding
}

protocol CustomMap {
    
    func initMapping<T>(_ type: T.Type, dict: [String: Any]) -> T?
}

class BaseRequest: BaseRequestProtocol {
    
    func method() -> HTTPMethod {
        return .post
    }
    
    func apiPath() ->String? {
        return nil
    }
    
    func headers() -> [String : String]? {
        return nil
    }
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    func rawData() -> Data? {
        return nil
    }
    
    func encoding() -> ParameterEncoding {
        switch method() {
        case .get:
            return URLEncoding.default
        case .post:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

enum ResponseType {
    case success(r: Any)
    case error(e: String)
}
