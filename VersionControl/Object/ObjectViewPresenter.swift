//
//  ObjectViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 04.10.2025.
//

import Combine


final class ObjectViewPresenter {
    private let defectService = DefectService()
    
    @Published private(set) var defects: [Defect] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // Метод для получения ограниченного количества дефектов для предварительного просмотра
    var previewDefects: [Defect] {
        return Array(defects.prefix(10))
    }
    
    func fetchDefects(idObject: Int) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let fetchedDefects = try await defectService.fetchDefects(idObject: idObject)
                await MainActor.run {
                    self.defects = fetchedDefects
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}
