//
//  RegistrationViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 07.09.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    
    var presenter: RegistrationViewPresenter?
    
    private lazy var logLabel: UILabel = {
        let view = UILabel()
        view.text = "Вход"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        
        // Отступы внутри поля
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        
        // Отступы внутри поля
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        return textField
    }()
    
    private lazy var logButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Начать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logButton)
        addConstraints()
        setupKeyboardHandling()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            logLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 132),
            logLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextField.topAnchor.constraint(equalTo: logLabel.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            logButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func logButtonTapped() {
        print(emailTextField.text, passwordTextField.text)
    }
}

extension LoginViewController {
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Скрытие клавиатуры по тапу
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else { return }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: RegistrationViewDelegate {
    func endLogin() {
        <#code#>
    }
}
