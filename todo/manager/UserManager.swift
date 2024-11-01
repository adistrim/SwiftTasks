//
//  UserManager.swift
//  todo
//
//  Created by Aditya Raj on 30/10/24.
//

import Foundation

class UserManager: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var username: String?
    @Published var isGuest: Bool
    @Published var userToken: String?
    
    private let defaults = UserDefaults.standard
    
    init() {
        self.isFirstLaunch = !defaults.bool(forKey: "hasLaunchedBefore")
        self.username = defaults.string(forKey: "username")
        self.isGuest = defaults.bool(forKey: "isGuest")
        self.userToken = defaults.string(forKey: "userToken")
    }
    
    func completeFirstLaunch() {
        defaults.set(true, forKey: "hasLaunchedBefore")
        isFirstLaunch = false
    }
    
    func setGuestUser(name: String) {
        username = name
        isGuest = true
        defaults.set(name, forKey: "username")
        defaults.set(true, forKey: "isGuest")
        completeFirstLaunch()
    }
    
    func setNormalUser(token: String, name: String) {
        username = name
        userToken = token
        isGuest = false
        
        defaults.set(name, forKey: "username")
        defaults.set(token, forKey: "userToken")
        defaults.set(false, forKey: "isGuest")
        completeFirstLaunch()
    }
    
    func logout() {
        username = nil
        userToken = nil
        isGuest = false
        
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "isGuest")
        
        defaults.removeObject(forKey: "hasLaunchedBefore")
        isFirstLaunch = true
    }
}
