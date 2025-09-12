//
//  ProfileViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import UIKit

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var helloView: UILabel = {
        let label = UILabel()
        label.text = "Вы успешно вошли"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(helloView)
        
        // Устанавливаем констрейнты после добавления на view
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            helloView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
