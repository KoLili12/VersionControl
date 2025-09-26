//
//  NetworkClient.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import Foundation

// MARK: - Network Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Client
final class NetworkClient {
    
    // MARK: - Properties
    private let session: URLSession
    private let baseURL: String?
    
    // MARK: - Initialization
    init(baseURL: String? = nil, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Generic Request Method
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let url = try buildURL(endpoint: endpoint, parameters: method == .GET ? parameters : nil)
        var request = URLRequest(url: url)
        
        // Configure request
        request.httpMethod = method.rawValue
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body for non-GET requests
        if method != .GET, let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.networkError(error)
            }
        }
        
        // Perform request
        do {
            let (data, response) = try await session.data(for: request)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.httpError(httpResponse.statusCode)
                }
            }
            
            // Decode response
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Convenience Methods
    
    // GET request
    func get<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .GET,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    // POST request
    func post<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .POST,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    // PUT request
    func put<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .PUT,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    // DELETE request
    func delete<T: Codable>(
        endpoint: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .DELETE,
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
    
    // Request without response decoding (for cases where you don't need response data)
    func request(
        endpoint: String,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> Data {
        
        let url = try buildURL(endpoint: endpoint, parameters: method == .GET ? parameters : nil)
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if method != .GET, let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.networkError(error)
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.httpError(httpResponse.statusCode)
                }
            }
            
            return data
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Helper Methods
    private func buildURL(endpoint: String, parameters: [String: Any]? = nil) throws -> URL {
        var urlString: String
        
        if let baseURL = baseURL {
            urlString = baseURL.hasSuffix("/") ? baseURL + endpoint : baseURL + "/" + endpoint
        } else {
            urlString = endpoint
        }
        
        // Add query parameters for GET requests
        if let parameters = parameters, !parameters.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlString = components?.url?.absoluteString ?? urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
}

// MARK: - NetworkClient Extension для загрузки файлов

extension NetworkClient {
    
    // Структура для файла
    struct FileUpload {
        let data: Data
        let filename: String
        let mimeType: String
        
        init(data: Data, filename: String, mimeType: String = "image/jpeg") {
            self.data = data
            self.filename = filename
            self.mimeType = mimeType
        }
    }
    
    // Загрузка файлов с multipart/form-data
    func uploadFiles<T: Codable>(
        endpoint: String,
        files: [FileUpload],
        parameters: [String: String] = [:],
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let url = try buildURL(endpoint: endpoint)
        var request = URLRequest(url: url)
        
        // Создаем boundary для multipart
        let boundary = "Boundary-\(UUID().uuidString)"
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Добавляем headers (например Authorization)
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Создаем multipart body
        var body = Data()
        
        // 1. Добавляем text параметры (entity_type, entity_id, etc.)
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // 2. Добавляем файлы
        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // 3. Закрываем boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Выполняем запрос
        do {
            let (data, response) = try await session.data(for: request)
            
            // Проверяем HTTP статус
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.httpError(httpResponse.statusCode)
                }
            }
            
            // Декодируем ответ
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // Convenience метод для загрузки одного файла
    func uploadFile<T: Codable>(
        endpoint: String,
        file: FileUpload,
        parameters: [String: String] = [:],
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await uploadFiles(
            endpoint: endpoint,
            files: [file],
            parameters: parameters,
            headers: headers,
            responseType: responseType
        )
    }
}
