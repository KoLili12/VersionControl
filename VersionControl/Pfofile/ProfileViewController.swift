//
//  ProfileViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import UIKit

import UIKit

class ProfileViewController: UIViewController {
    
    let service = LogOutService()
    
    lazy var helloView: UILabel = {
        let label = UILabel()
        label.text = "Вы успешно вошли"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.addTarget(self, action: #selector(exitButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(helloView)
        view.addSubview(exitButton)
        
        // Устанавливаем констрейнты после добавления на view
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            helloView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            exitButton.topAnchor.constraint(equalTo: helloView.bottomAnchor, constant: 32),
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func exitButtonDidTapped() {
        service.removeToken()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashScreenViewController()
    }
}
