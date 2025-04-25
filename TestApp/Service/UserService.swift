import Foundation
import Combine

protocol UserServiceType: Service {
    func getUsers(page: Int, count: Int) async throws -> UserModel
    func createUser(model: SignUpSectionsModel) async throws -> CreateUserModel
}

class UserService: UserServiceType {
    
    func getUsers(page: Int, count: Int) async throws -> UserModel {
        let request = GetUsersRequest(count: count, page: page)
        return try await request.perform().data
    }
    
    func createUser(model: SignUpSectionsModel) async throws -> CreateUserModel {
        let request = CreateNewUsersRequest(model: model)
        return try await request.perform().data
    }
}
