//
//  WelcomeView.swift
//  todo
//
//  Created by Aditya Raj on 30/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showGuestNamePrompt = false
    @State private var guestName = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    VStack(spacing: 16) {
                        Text("SwiftTask")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Organize your tasks seamlessly")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 16) {
                        FeatureRow(icon: "checkmark.circle.fill", title: "Track Tasks", description: "Organize and manage your tasks efficiently")
                        FeatureRow(icon: "arrow.triangle.2.circlepath.icloud.fill", title: "Sync & Backup", description: "Create an account to sync your tasks across devices")
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        NavigationLink(destination: CreateAccountView()) {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Create Account")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            HStack {
                                Image(systemName: "person.circle")
                                Text("Login")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showGuestNamePrompt = true
                        }) {
                            HStack {
                                Image(systemName: "person")
                                Text("Continue as Guest")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("By creating an account, you'll be able to sync your tasks across devices and never lose your data.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 40)
            }
            .alert("Enter Your Name", isPresented: $showGuestNamePrompt) {
                TextField("Your Name", text: $guestName)
                Button("Continue") {
                    if !guestName.isEmpty {
                        userManager.setGuestUser(name: guestName)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Note: Guest mode stores data locally only. Create an account to sync across devices.")
            }
            .navigationTitle("Welcome")
        }
    }
}
