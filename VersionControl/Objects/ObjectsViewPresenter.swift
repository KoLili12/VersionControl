//
//  ObjectsViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import Foundation

final class ObjectsViewPresenter {
    weak var delegate: ObjectsViewDelegate?
    let objectsService = ObjectsService()
    
    private var objects: [Object] = []
    
    var numberOfObjects: Int {
        return objects.count
    }
    
    func fetchObjects() {
        Task {
            do {
               let response = try await objectsService.fetchObjects()
                objects.append(contentsOf: response)
                print(objects)
                await MainActor.run {
                    delegate?.updateTableView()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getObject(at index: Int) -> Object {
        return objects[index]
    }
    
    func refreshData() {
        objects = []
        fetchObjects()
    }
}
