//
//  ObjectsService.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import Foundation


final class ObjectsService {
    let client = NetworkClient(baseURL: "http://localhost:8080")
    let tokenStorage = TokenStorage()
    
    func fetchObjects() async throws -> [Object] {
        guard let token = tokenStorage.token else {
            throw NetworkError.httpError(401)
        }
        
        let response = try await client.get(endpoint: "api/v1/projects?page=1&limit=10", headers: ["Authorization": "Bearer \(token)"], responseType: ObjectsResponse.self)
        return response.objects
    }
    
    func addObject(object: ObjectForRequest, photo: Data?) async throws -> String {
        guard let token = tokenStorage.token else {
            throw NetworkError.httpError(401)
        }
        
        let response = try await client.post(
            endpoint: "api/v1/projects",
            parameters: [
                "name": object.name,
                "description": object.description,
                "address": object.address,
                "start_date": object.startDate,
                "end_date": object.endDate
            ],
            headers: ["Authorization": "Bearer \(token)"],
            responseType: CreateObjectResponse.self
        )
        
        // Если есть фото, загружаем его через multipart/form-data
        if let photo = photo {
            let file = NetworkClient.FileUpload(
                data: photo,
                filename: "project_\(response.object.id).png",
                mimeType: "image/png"
            )
            
            let _ = try await client.uploadFile(
                endpoint: "api/v1/files/upload",
                file: file,
                parameters: [
                    "entity_type": "project",
                    "entity_id": "\(response.object.id)"
                ],
                headers: ["Authorization": "Bearer \(token)"],
                responseType: UploadedFilesResponse.self
            )
        }
        
        return response.message
    }
    
    func deleteObject(object: ObjectForRequest, photo: Data?) async throws -> String {
        
    }
    
    
    
}
