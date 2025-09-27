//
//  User.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

// MARK: - Main Response Model
struct LoginResponse: Codable {
   let message: String
   let token: String
   let user: User
}

struct GetUserResponse: Codable {
    let user: User
}

// MARK: - User Model
struct User: Codable {
   let email: String
   let firstName: String
   let id: Int
   let lastName: String
   let phone: String
   let role: Role
   
   private enum CodingKeys: String, CodingKey {
       case email
       case firstName = "first_name"
       case id
       case lastName = "last_name"
       case phone
       case role
   }
}

// MARK: - Role Model
struct Role: Codable {
   let code: String
   let id: Int
   let name: String
}

enum UserRole: String, CaseIterable {
    case manager = "manager"
    case observer = "observer"
    case engineer = "engineer"
    
    var displayName: String {
        switch self {
        case .manager: return "Менеджер"
        case .observer: return "Наблюдатель"
        case .engineer: return "Инженер"
        }
    }
}
