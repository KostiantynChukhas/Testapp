import Foundation
import UIKit
import Alamofire

enum RequestResultCodable<T: Decodable> {
    case success(response: T)
    case error(message: String?)
}

enum RequestError: Error {
    case invalidURL
    case parsingFailed
    case mockupDataMissing
    case custom(message: String)
}

typealias RequestClosure<T:Decodable> = (RequestResultCodable<T>) -> ()

let parseErrorString = "Error, Please try later"
let parseBundleString = "Error on parse data from bundle"

struct RequestResultCodableAsync<T: Decodable>: Decodable {
    let data: T
}

final class RequestManager {
    
    let decoder = JSONDecoder()
    static let shared = RequestManager()
    
    init() {
        AF.session.configuration.timeoutIntervalForRequest = 15.0
    }
    
    // MARK: - New Async Method
    func performRequest<T: Decodable>(_ requestItem: BaseRequestProtocol, to classType: T.Type) async throws -> RequestResultCodableAsync<T> {
        let fullPath = requestItem.apiPath() ?? ""
        let parameters: [String: Any] = requestItem.parameters() ?? [:]
        let headers: [String: String] = requestItem.headers() ?? [:]
        
        guard let path = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let fullPathUrl = URL(string: path) else {
            throw RequestError.invalidURL
        }
        
        let httpHeaders = HTTPHeaders(headers)
        let request = try URLRequest(url: fullPathUrl, method: requestItem.method(), headers: httpHeaders)
        
        let encoding = requestItem.encoding()
        let encodedRequest = try encoding.encode(request, with: parameters)
        
        var finalRequest = encodedRequest
        
        if let jsonData = requestItem.rawData() {
            finalRequest.httpBody = jsonData
        }
#if DEBUG
        print("\n🔵 HEADERS \(headers)")
        print("🔵 \(requestItem.method().rawValue) \(fullPath)")
        print("🔵 PARAMS \(parameters) \n")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("🔵 PARAMS JSON:\n\(jsonString)")
        }
#endif
        
        let session = Session.default
        let response = try await session.request(finalRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(classType, decoder: decoder)
            .value
        
#if DEBUG
        let responseData = try await session.request(finalRequest)
            .validate(statusCode: 200..<300)
            .serializingData()
            .value
        
        if let jsonString = String(data: responseData, encoding: .utf8) {
            print("🟢 RESPONSE JSON:\n\(jsonString)")
        }
#endif
        return RequestResultCodableAsync(data: response)
    }
    
    private func parseJSON<T: Decodable>(from data: Data, to classType: T.Type) throws -> T {
        do {
            return try decoder.decode(classType, from: data)
        } catch {
            if let decodingError = error as? DecodingError {
                print(decodingError.localizedDescription)
            }
            throw RequestError.parsingFailed
        }
    }
    
    // MARK: - Error Handling
    private func getErrorMessage(data: Data?) -> String? {
        guard let jsonData = data,
              let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return nil
        }
        
        if let message = dict["message"] as? String {
            return message
        }
        
        return nil
    }
}

extension RequestManager {
    func performMultipartRequest<T: Decodable>(
        _ requestItem: BaseRequestProtocol,
        to classType: T.Type,
        files: [(data: Data, name: String, fileName: String, mimeType: String)]
    ) async throws -> RequestResultCodableAsync<T> {
        
        let fullPath = requestItem.apiPath() ?? ""
        let parameters: [String: Any] = requestItem.parameters() ?? [:]
        let headers: [String: String] = requestItem.headers() ?? [:]
        
        guard let fullPathUrl = URL(string: fullPath) else {
            throw RequestError.invalidURL
        }
        
        let httpHeaders = HTTPHeaders(headers)
        
        print("\n🔵 HEADERS \(headers)")
        print("🔵 MULTIPART POST \(fullPath)")
        print("🔵 PARAMS \(parameters) \n")
        print("🔵 Uploading files: \(files.map { $0.fileName })")
        
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                // Добавляем каждый параметр формы
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                // Добавляем файл
                for file in files {
                    multipartFormData.append(
                        file.data,
                        withName: file.name,
                        fileName: file.fileName,
                        mimeType: file.mimeType
                    )
                }
            },
                      to: fullPathUrl,
                      method: .post,
                      headers: httpHeaders)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: classType, decoder: decoder) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: RequestResultCodableAsync(data: value))
                case .failure(let error):
                    if let data = response.data,
                       let errorString = String(data: data, encoding: .utf8) {
                        print("🔴 Server response: \(errorString)")
                    }
                    print("🔴 Error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
