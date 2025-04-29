import Foundation
import Combine

protocol UserServiceType: Service {
    func getUsers(page: Int, count: Int) async throws -> UserModel
    func createUser(model: SignUpSectionsModel, token: String) async throws -> CreateUserModel
    func getToken() async throws -> TokenModel
}

class UserService: UserServiceType {
    
    func getUsers(page: Int, count: Int) async throws -> UserModel {
        let request = GetUsersRequest(count: count, page: page)
        return try await request.perform().data
    }
    
    func createUser(model: SignUpSectionsModel, token: String) async throws -> CreateUserModel {
        let request = CreateNewUsersRequest(model: model, token: token)
        return try await request.perform().data
    }
    
    func getToken() async throws -> TokenModel {
        let request = GetTokenRequest()
        return try await  request.perform().data
    }
}
