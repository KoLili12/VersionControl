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
    
    func fetchDefects(idObject: Int) {
        Task {
            do {
                let defects = try await defectService.fetchDefects(idObject: idObject)
                await MainActor.run {
                    self.defects = defects
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
