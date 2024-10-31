//
//  LoginView.swift
//  todo
//
//  Created by Aditya Raj on 31/10/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Log in to continue using SwiftTask")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .font(.headline)
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Text("Password")
                        .font(.headline)
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: login) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(isLoading)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: CreateAccountView()){
                        Text("Create Account").foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .padding(.vertical, 40)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            isLoading = false
            return
        }
        
        let loginData = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
            errorMessage = "Error preparing login data"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: URL(string: "https://swift-tasks-server.vercel.app/api/auth/login")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = jsonResponse["token"] as? String,
                       let name = jsonResponse["name"] as? String {
                        userManager.setNormalUser(token: token, name: name)
                        print("Login successful. User data saved.")
                    } else {
                        errorMessage = "Invalid credentials"
                    }
                } catch {
                    errorMessage = "Error parsing response"
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
