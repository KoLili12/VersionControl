
//
//  Defect.swift
//  VersionControl
//
//  Created by Николай Жирнов on 01.10.2025.
//

import Foundation

// MARK: - Defects Response
struct DefectsResponse: Codable {
    let defects: [Defect]
    let pagination: Pagination
}

// MARK: - Create Defect Response
struct CreateDefectResponse: Codable {
    let message: String
    let defect: Defect
}

// MARK: - Defect Model
struct Defect: Codable, Identifiable {
    let id: Int
    let projectId: Int
    let projectName: String
    let title: String
    let description: String
    let status: DefectStatus
    let priority: DefectPriority
    let creator: DefectCreator
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case projectName = "project_name"
        case title, description, status, priority, creator
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Defect Creator
struct DefectCreator: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

// MARK: - Defect Status Enum
enum DefectStatus: String, Codable, CaseIterable {
    case registered = "registered"
    case inProgress = "in_progress"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .registered: return "Зарегистрирован"
        case .inProgress: return "В работе"
        case .completed: return "Завершен"
        }
    }
    
    var color: String {
        switch self {
        case .registered: return "orange"
        case .inProgress: return "blue"
        case .completed: return "green"
        }
    }
}

// MARK: - Defect Priority Enum
enum DefectPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var displayName: String {
        switch self {
        case .low: return "Низкий"
        case .medium: return "Средний"
        case .high: return "Высокий"
        case .critical: return "Критический"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "gray"
        case .medium: return "yellow"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
}

// MARK: - Defect For Request
struct DefectForRequest: Codable {
    let projectId: Int
    let title: String
    let description: String
    let priority: String
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case title, description, priority
    }
}

// MARK: - Defect Status Update
struct DefectStatusUpdate: Codable {
    let status: String
}

// MARK: - Defect Stats Response
struct DefectStatsResponse: Codable {
    let projectId: Int
    let stats: DefectStats
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case stats
    }
}

// MARK: - Defect Stats
struct DefectStats: Codable {
    let total: Int
    let registered: Int
    let inProgress: Int
    let completed: Int
    
    enum CodingKeys: String, CodingKey {
        case total, registered
        case inProgress = "in_progress"
        case completed
    }
}
