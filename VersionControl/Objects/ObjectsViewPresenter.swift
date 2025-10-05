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
    
    func deleteObject(at index: Int) {
        Task {
            do {
                print(4)
                let _ = try await objectsService.deleteObject(objectID: getObject(at: index).id)
                await MainActor.run {
                    refreshData()
                }
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
