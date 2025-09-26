//
//  ObjectsViewDelegate.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import Foundation

protocol ObjectsViewDelegate: AnyObject {
    func updateTableView()
}

protocol ObjectsViewUpdateDelegate: AnyObject {
    func updateData()
}
