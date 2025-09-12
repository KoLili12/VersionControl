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
                await MainActor.run {
                    delegate?.endSuccessLogin(token: token)
                }
                
            } catch {
                await MainActor.run {
                    delegate?.endErrorLogin()
                }
            }
        }
    }
    
}
