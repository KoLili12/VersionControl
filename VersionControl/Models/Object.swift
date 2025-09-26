//
//  Object.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import Foundation

// MARK: - Projects Response Model
struct ObjectsResponse: Codable {
    let pagination: Pagination
    let objects: [Object]
    
    enum CodingKeys: String, CodingKey {
        case pagination
        case objects = "projects"
    }
}

struct CreateObjectResponse: Codable {
    let message: String
    let object: Object
    
    enum CodingKeys: String, CodingKey {
        case message
        case object = "project"
    }
}

struct UploadedFilesResponse: Codable {
    let uploadedFiles: [File]
    enum CodingKeys: String, CodingKey {
        case uploadedFiles = "uploaded_files"
    }
}

// MARK: - Pagination Model
struct Pagination: Codable {
    let currentPage: Int
    let limit: Int
    let totalItems: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case limit
        case totalItems = "total_items"
        case totalPages = "total_pages"
    }
}

// MARK: - Project Model
struct Object: Codable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let status: String
    let startDate: String
    let endDate: String
    let createdBy: Int
    let creator: User
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, address, status
        case startDate = "start_date"
        case endDate = "end_date"
        case createdBy = "created_by"
        case creator
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct File: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "file_name"
    }
}

struct ObjectForRequest: Codable {
    let name: String
    let description: String
    let address: String
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case name, description, address
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
