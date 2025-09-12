//
//  LogOutService.swift
//  VersionControl
//
//  Created by Николай Жирнов on 12.09.2025.
//

import Foundation

final class LogOutService {
    let tokenStorage = TokenStorage()
    
    
    
    func removeToken() {
        tokenStorage.deleteToken()
    }
    
    // тута в будущем будут другие методы очистки, пока ток токен :)
}
