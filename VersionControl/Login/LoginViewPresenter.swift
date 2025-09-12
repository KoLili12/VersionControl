//
//  RegistrationViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import Foundation

final class LoginViewPresenter {
    weak var delegate: LoginViewDelegate?
    let authService = AuthService()
    
    func performLogin(email: String, password: String) {
        Task {
            do {
                let token = try await authService.login(email: email, password: password)
                print(token)
                // Возвращаемся на главный поток для обновления UI
                await MainActor.run {
                    delegate?.endSuccessLogin()
                }
                
            } catch {
                await MainActor.run {
                    delegate?.endErrorLogin()
                }
            }
        }
    }
    
}
