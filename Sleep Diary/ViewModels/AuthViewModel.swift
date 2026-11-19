import Foundation
import Combine
import Security
import LocalAuthentication

class AuthViewModel: ObservableObject {

    @Published var isAuthenticated = false
    @Published var errorMessage: String? = nil

    @Published var currentName = ""
    @Published var currentEmail = ""

    private let service = "SleepDiaryAuthentication"

    // MARK: - Sign Up

    func signUp(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) -> Bool {

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        guard !cleanName.isEmpty,
              !cleanEmail.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        guard cleanEmail.contains("@"),
              cleanEmail.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        guard password.count >= 8 else {
            errorMessage = "Password must contain at least 8 characters."
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        if UserDefaults.standard.string(forKey: "userEmail") != nil {
            errorMessage = "An account already exists. Please log in."
            return false
        }

        guard savePassword(password, for: cleanEmail) else {
            errorMessage = "Unable to create account. Please try again."
            return false
        }

        UserDefaults.standard.set(cleanName, forKey: "userName")
        UserDefaults.standard.set(cleanEmail, forKey: "userEmail")

        currentName = cleanName
        currentEmail = cleanEmail
        errorMessage = nil

        return true
    }

    // MARK: - Login

    func login(email: String, password: String) -> Bool {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        guard let savedEmail = UserDefaults.standard.string(
            forKey: "userEmail"
        ), cleanEmail == savedEmail else {

            errorMessage = "Account not found. Please sign up first."
            return false
        }

        guard let savedPassword = getPassword(for: cleanEmail),
              savedPassword == password else {

            errorMessage = "Incorrect password. Please try again."
            return false
        }

        currentName = UserDefaults.standard.string(
            forKey: "userName"
        ) ?? ""

        currentEmail = cleanEmail
        isAuthenticated = true
        errorMessage = nil

        return true
    }

    // MARK: - Face ID

    func authenticate() {

        guard UserDefaults.standard.string(
            forKey: "userEmail"
        ) != nil else {
            errorMessage = "Please create an account before using Face ID."
            return
        }

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            errorMessage = "Face ID is unavailable. Please use your password."
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Unlock your Sleep Diary"
        ) { [weak self] success, _ in

            DispatchQueue.main.async {

                if success {
                    self?.currentName = UserDefaults.standard.string(
                        forKey: "userName"
                    ) ?? ""

                    self?.currentEmail = UserDefaults.standard.string(
                        forKey: "userEmail"
                    ) ?? ""

                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage = "Face ID failed. Please try again."
                }
            }
        }
    }

    // MARK: - Logout

    func logout() {
        isAuthenticated = false
        errorMessage = nil
    }

    // MARK: - Save Password in Keychain

    private func savePassword(
        _ password: String,
        for email: String
    ) -> Bool {

        let data = Data(password.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        return status == errSecSuccess
    }

    // MARK: - Read Password from Keychain

    private func getPassword(for email: String) -> String? {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
