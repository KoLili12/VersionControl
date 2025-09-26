//
//  AddObjectViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 18.09.2025.
//

import Foundation

final class AddObjectViewPresenter {
    weak var delegate: AddObjectDelegate?
    private let objectsService = ObjectsService()
    
    func addObject(object: ObjectForRequest, photo: Data?) {
        Task {
            do {
                let response = try await objectsService.addObject(object: object, photo: photo)
                await MainActor.run {
                    self.delegate?.objectDidAdd()
                }
            } catch {
                print("Ошибка при добавлении объекта")
            }
        }
    }
}
