//
//  LocalStorageService.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import Foundation

public struct LocalStorageService {
    
    private static let key = "api_token"
    private static let userDefaults = UserDefaults.standard
    
    static func getToken() -> String? {
        userDefaults.string(forKey: key)
    }
    
    static func save(token: String) {
        userDefaults.set(token, forKey: key)
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: key)
    }
    
}
