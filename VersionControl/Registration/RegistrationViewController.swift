//
//  RegistrationViewController.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import UIKit
import ProgressHUD

class RegistrationViewController: UIViewController {
    var presenter: RegistrationViewPresenter?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registrationLabel: UILabel = {
        let view = UILabel()
        view.text = "Регистрация"
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
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
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
    
    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
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
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+7 (000) 000-00-00"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .phonePad
        
        // Отступы внутри поля
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return textField
    }()
    
    private lazy var roleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выберите роль", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showRoleSelection), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(backButton)
        view.addSubview(registrationLabel)
        view.addSubview(roleButton)
        view.addSubview(registrationButton)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(surnameTextField)
        // Do any additional setup after loading the view.
        addConstraints()
    }
    
    
    private var selectedRole: UserRole? {
        didSet {
            if let role = selectedRole {
                roleButton.setTitle(role.displayName, for: .normal)
                roleButton.setTitleColor(.label, for: .normal)
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            registrationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            phoneTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 8),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            roleButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 8),
            roleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            roleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            roleButton.heightAnchor.constraint(equalToConstant: 44),
            
            registrationButton.topAnchor.constraint(equalTo: roleButton.bottomAnchor, constant: 24),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc private func showRoleSelection() {
        let alert = UIAlertController(title: "Выберите роль", message: nil, preferredStyle: .actionSheet)
        
        for role in UserRole.allCases {
            let action = UIAlertAction(title: role.displayName, style: .default) { _ in
                self.selectedRole = role
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = roleButton
            popover.sourceRect = roleButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    
    @objc private func phoneTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let digits = text.filter { $0.isNumber }
        
        let limitedDigits = String(digits.prefix(11))
        
        var displayText = "+7"
        
        if limitedDigits.count > 1 {
            let phoneDigits = String(limitedDigits.dropFirst())
            
            if phoneDigits.count > 0 {
                displayText += " ("
                displayText += String(phoneDigits.prefix(3))
                
                if phoneDigits.count > 3 {
                    displayText += ") "
                    displayText += String(phoneDigits.dropFirst(3).prefix(3))
                    
                    if phoneDigits.count > 6 {
                        displayText += "-"
                        displayText += String(phoneDigits.dropFirst(6).prefix(2))
                        
                        if phoneDigits.count > 8 {
                            displayText += "-"
                            displayText += String(phoneDigits.dropFirst(8).prefix(2))
                        }
                    }
                }
            }
        }
        textField.text = displayText
    }
    
    @objc func registrationButtonTapped() {
        let phoneDigits = phoneTextField.text?.filter { $0.isNumber } ?? ""
        let cleanPhone = phoneDigits.count > 1 ? "+7" + String(phoneDigits.dropFirst()) : ""
        
        print("=== Данные регистрации ===")
        print("Email: \(emailTextField.text ?? "")")
        print("Пароль: \(passwordTextField.text ?? "")")
        print("Имя: \(nameTextField.text ?? "")")
        print("Фамилия: \(surnameTextField.text ?? "")")
        print("Телефон (отображение): \(phoneTextField.text ?? "")")
        print("Телефон (для хранения): \(cleanPhone)")
        print("Роль (отображение): \(selectedRole?.displayName ?? "")")
        print("Роль (для хранения): \(selectedRole?.rawValue ?? "")")
        print("========================")
        
        ProgressHUD.animate()
        presenter?.performRegistration(email: emailTextField.text ?? "",
                                       password: passwordTextField.text ?? "",
                                       firstName: nameTextField.text ?? "",
                                       lastName: surnameTextField.text ?? "",
                                       phone: cleanPhone,
                                       roleСode: selectedRole?.rawValue ?? "")
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension RegistrationViewController: RegistrationViewDelegate {
    func endSuccessRegistration(token: String) {
        ProgressHUD.dismiss()
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func endErrorRegistration() {
        ProgressHUD.dismiss()
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось создать аккаунт", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
