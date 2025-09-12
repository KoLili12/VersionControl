//
//  RegistrationViewPresenter.swift
//  VersionControl
//
//  Created by Николай Жирнов on 09.09.2025.
//

import Foundation

final class RegistrationViewPresenter {
    weak var delegate: RegistrationViewDelegate?
    let authService = AuthService()
    
    func performRegistration(email: String, password: String, firstName: String, lastName: String, phone: String, roleСode: String) {
        Task {
            do {
                let token = try await authService.registration(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone, roleСode: roleСode)
                print(token)
                // Возвращаемся на главный поток для обновления UI
                await MainActor.run {
                    delegate?.endSuccessRegistration(token: token)
                }
                
            } catch {
                await MainActor.run {
                    delegate?.endErrorRegistration()
                }
            }
        }
    }
}
