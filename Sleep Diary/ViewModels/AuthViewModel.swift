//
//  AuthViewModel.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 18/11/26.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {

    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let biometricService = BiometricService()

    // Face ID / Device Passcode Authentication
    func authenticate() {
        isLoading = true
        errorMessage = nil

        biometricService.authenticate { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.isAuthenticated = success
                self?.errorMessage = error
            }
        }
    }

    // Manual Login
    func manualLogin(email: String, password: String) {

        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter email and password."
            return
        }

        if !email.contains("@") {
            errorMessage = "Please enter a valid email."
            return
        }

        if password.count < 6 {
            errorMessage = "Password must contain at least 6 characters."
            return
        }

        isAuthenticated = true
        errorMessage = nil
    }

    func logout() {
        isAuthenticated = false
    }
}
