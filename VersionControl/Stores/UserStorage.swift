//
//  UserStorage.swift
//  VersionControl
//
//  Created by Николай Жирнов on 26.09.2025.
//

import Foundation

/// Синглтон для хранения данных о пользователе
final class UserStorage {
    
    // MARK: - Singleton
    static let shared = UserStorage()
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - User Data Keys
    private enum Keys {
        static let userId = "user_id"
        static let username = "username"
        static let userEmail = "user_email"
        static let userToken = "user_token"
        static let isLoggedIn = "is_logged_in"
        static let userPreferences = "user_preferences"
        static let lastLoginDate = "last_login_date"
    }
    
    // MARK: - Initialization
    private init() {
        // Приватный инициализатор для синглтона
    }
    
    // MARK: - User ID
    var userId: String? {
        get { userDefaults.string(forKey: Keys.userId) }
        set { userDefaults.set(newValue, forKey: Keys.userId) }
    }
    
    // MARK: - Username
    var username: String? {
        get { userDefaults.string(forKey: Keys.username) }
        set { userDefaults.set(newValue, forKey: Keys.username) }
    }
    
    // MARK: - User Email
    var userEmail: String? {
        get { userDefaults.string(forKey: Keys.userEmail) }
        set { userDefaults.set(newValue, forKey: Keys.userEmail) }
    }
    
    // MARK: - Authentication Token
    var userToken: String? {
        get { userDefaults.string(forKey: Keys.userToken) }
        set { 
            if let token = newValue {
                userDefaults.set(token, forKey: Keys.userToken)
            } else {
                userDefaults.removeObject(forKey: Keys.userToken)
            }
        }
    }
    
    // MARK: - Login Status
    var isLoggedIn: Bool {
        get { userDefaults.bool(forKey: Keys.isLoggedIn) }
        set { userDefaults.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    // MARK: - Last Login Date
    var lastLoginDate: Date? {
        get { userDefaults.object(forKey: Keys.lastLoginDate) as? Date }
        set { userDefaults.set(newValue, forKey: Keys.lastLoginDate) }
    }
    
    // MARK: - User Preferences
    var userPreferences: [String: Any]? {
        get { userDefaults.dictionary(forKey: Keys.userPreferences) }
        set { userDefaults.set(newValue, forKey: Keys.userPreferences) }
    }
    
    // MARK: - Public Methods
    
    /// Сохраняет данные пользователя
    func saveUserData(userId: String?, username: String?, email: String?, token: String?) {
        self.userId = userId
        self.username = username
        self.userEmail = email
        self.userToken = token
        self.isLoggedIn = token != nil
        self.lastLoginDate = Date()
        
        userDefaults.synchronize()
    }
    
    /// Очищает все данные пользователя
    func clearUserData() {
        userId = nil
        username = nil
        userEmail = nil
        userToken = nil
        isLoggedIn = false
        lastLoginDate = nil
        userPreferences = nil
        
        userDefaults.synchronize()
    }
    
    /// Проверяет, авторизован ли пользователь
    func isUserAuthenticated() -> Bool {
        return isLoggedIn && userToken != nil && !userToken!.isEmpty
    }
    
    /// Сохраняет предпочтения пользователя
    func savePreference(key: String, value: Any) {
        var preferences = userPreferences ?? [:]
        preferences[key] = value
        userPreferences = preferences
        userDefaults.synchronize()
    }
    
    /// Получает предпочтение пользователя
    func getPreference<T>(key: String, defaultValue: T) -> T {
        return userPreferences?[key] as? T ?? defaultValue
    }
    
    /// Удаляет предпочтение пользователя
    func removePreference(key: String) {
        var preferences = userPreferences ?? [:]
        preferences.removeValue(forKey: key)
        userPreferences = preferences
        userDefaults.synchronize()
    }
}

// MARK: - Convenience Extensions
extension UserStorage {
    
    /// Быстрая проверка наличия токена
    var hasValidToken: Bool {
        guard let token = userToken else { return false }
        return !token.isEmpty
    }
    
    /// Получает полное имя пользователя или email, если имя недоступно
    var displayName: String {
        return username ?? userEmail ?? "Пользователь"
    }
    
    /// Проверяет, был ли пользователь активен недавно (последние 30 дней)
    var isRecentlyActive: Bool {
        guard let lastLogin = lastLoginDate else { return false }
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return lastLogin > thirtyDaysAgo
    }
}
