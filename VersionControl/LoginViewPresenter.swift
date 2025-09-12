//
//  RegistrationViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import Foundation

final class LoginViewPresenter {
    weak var delegate: LoginViewDelegate?
    
    func performLogin(email: String, password: String) {
        Task {
            do {
                let token = try await authService.login(email: email, password: password)
                
                // Возвращаемся на главный поток для обновления UI
                await MainActor.run {
                    setLoading(false)
                    handleSuccessfulLogin(token: token)
                }
                
            } catch {
                await MainActor.run {
                    setLoading(false)
                    handleLoginError(error)
                }
            }
        }
    }
    
}
