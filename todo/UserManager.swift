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
    
    private let defaults = UserDefaults.standard
    
    init() {
        self.isFirstLaunch = !defaults.bool(forKey: "hasLaunchedBefore")
        self.username = defaults.string(forKey: "username")
        self.isGuest = defaults.bool(forKey: "isGuest")
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
}
