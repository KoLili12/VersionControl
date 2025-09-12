//
//  AuthService.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import Foundation

final class AuthService {
    let client = NetworkClient(baseURL: "http://localhost:8080")
    
    func login(email: String, password: String) async throws -> String {
        let response = try await client.post(endpoint: "api/v1/auth/login", parameters: ["email": email, "password": password], responseType: LoginResponse.self)
        return response.token
    }
    
    func registration(email: String, password: String, firstName: String, lastName: String, phone: String, roleСode: String) async throws -> String {
        let response = try await client.post(endpoint: "api/v1/auth/register", parameters: ["email": email, "password": password, "first_name": firstName, "last_name": lastName, "phone": phone, "role_code": roleСode], responseType: LoginResponse.self)
        return response.token
    }
}
