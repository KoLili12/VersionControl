//
//  UserStorage.swift
//  VersionControl
//
//  Created by Николай Жирнов on 26.09.2025.
//

import Foundation

/// Синглтон для хранения данных о пользователе
final class UserStorage {
    private var user: User?
    
    private let client = NetworkClient(baseURL: "http://localhost:8080")
    private let tokenStorage = TokenStorage()
    
    // MARK: - Singleton
    static let shared = UserStorage()

    private init() { }
    
    func getUser() async throws -> User? {
        guard let token = tokenStorage.token else {
            throw NetworkError.httpError(401)
        }
        
        if let user {
            return user
        } else {
            let request = try await client.request(endpoint: "api/v1/profile", headers: ["Authorization": "Bearer \(token)"], responseType: GetUserResponse.self)
            return request.user
        }
    }
}
