import Foundation
import LocalAuthentication

class BiometricService {

    func authenticate(completion: @escaping (Bool, String?) -> Void) {

        let context = LAContext()
        var error: NSError?

        // Check Face ID availability
        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {

            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock your Sleep Diary"
            ) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(
                            false,
                            authenticationError?.localizedDescription
                        )
                    }
                }
            }

        } else {
            DispatchQueue.main.async {
                completion(
                    false,
                    "Face ID is unavailable. Please use manual login."
                )
            }
        }
    }
}
