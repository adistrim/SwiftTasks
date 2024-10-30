//
//  todoApp.swift
//  todo
//
//  Created by Aditya Raj on 29/10/24.
//

import SwiftUI

@main
struct todoApp: App {
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            if userManager.isFirstLaunch {
                WelcomeView().environmentObject(userManager)
            } else {
                ContentView().environmentObject(userManager)
            }
        }
    }
}
