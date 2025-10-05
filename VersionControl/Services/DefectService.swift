//
//  DefectService.swift
//  VersionControl
//
//  Created by Николай Жирнов on 04.10.2025.
//

import Foundation

final class DefectService {
    let client = NetworkClient(baseURL: "http://localhost:8080")
    let tokenStorage = TokenStorage()
    
    func fetchDefects(idObject: Int) async throws -> [Defect] {
        
        guard let token = tokenStorage.token else {
            throw NetworkError.httpError(401)
        }
        
        let request = try await client.get(
            endpoint: "api/v1/defects?project_id=\(idObject)",
            headers: ["Authorization": "Bearer \(token)"],
            responseType: DefectsResponse.self)
        return request.defects
    }
}
