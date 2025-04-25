import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let success: Bool?
    let totalPages, totalUsers, count, page: Int?
    let users: [User]?

    enum CodingKeys: String, CodingKey {
        case success
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case count, page, users
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email, phone, position: String?
    let positionID, registrationTimestamp: Int?
    let photo: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionID = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}
