import SwiftUI

struct SignupView: View {

    @ObservedObject var authViewModel: AuthViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationSuccess = false

    private let purple = Color(
        red: 0.68,
        green: 0.32,
        blue: 1.0
    )

    var body: some View {

        ZStack(alignment: .top) {

            // Background

            LinearGradient(
                colors: [
                    .black,
                    Color(red: 0.12, green: 0.05, blue: 0.22),
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            StarBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            // Signup Form

            ScrollView(showsIndicators: false) {

                VStack(spacing: 22) {

                    Spacer(minLength: 35)

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 55))
                        .foregroundColor(purple)
                        .shadow(color: purple, radius: 15)

                    Text("Create Account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Start your better sleep journey")
                        .foregroundColor(.white.opacity(0.7))

                    inputField(
                        title: "Full Name",
                        placeholder: "Enter your name",
                        text: $name,
                        icon: "person",
                        isSecure: false
                    )

                    inputField(
                        title: "Email Address",
                        placeholder: "Enter your email",
                        text: $email,
                        icon: "envelope",
                        isSecure: false
                    )

                    inputField(
                        title: "Password",
                        placeholder: "Minimum 8 characters",
                        text: $password,
                        icon: "lock",
                        isSecure: true
                    )

                    inputField(
                        title: "Confirm Password",
                        placeholder: "Re-enter your password",
                        text: $confirmPassword,
                        icon: "lock.fill",
                        isSecure: true
                    )

                    // Create Account

                    Button {
                        registerUser()
                    } label: {

                        Text("CREATE ACCOUNT")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        purple,
                                        .purple
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 15)
                            )
                            .shadow(
                                color: purple.opacity(0.35),
                                radius: 12
                            )
                    }

                    // Login Navigation

                    HStack(spacing: 5) {

                        Text("Already have an account?")
                            .foregroundColor(.white.opacity(0.7))

                        Button("Login") {
                            dismiss()
                        }
                        .foregroundColor(purple)
                        .bold()
                    }
                    .font(.subheadline)

                    Text("Your sleep. Your health. Your journey.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 10)
                }
                .padding(25)
            }

            // TOP NOTIFICATION

            if showNotification {

                HStack(spacing: 12) {

                    Image(
                        systemName: notificationSuccess
                        ? "checkmark.circle.fill"
                        : "exclamationmark.circle.fill"
                    )
                    .font(.title2)
                    .foregroundColor(
                        notificationSuccess ? .green : .red
                    )

                    Text(notificationMessage)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)
                }
                .padding()
                .background(
                    Color(red: 0.16, green: 0.08, blue: 0.27)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            purple.opacity(0.7),
                            lineWidth: 1
                        )
                }
                .shadow(color: purple.opacity(0.3), radius: 12)
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .transition(
                    .move(edge: .top).combined(with: .opacity)
                )
                .zIndex(1)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Input Field

    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String,
        isSecure: Bool
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .foregroundColor(.white)
                .font(.headline)

            HStack {

                Image(systemName: icon)
                    .foregroundColor(purple)

                if isSecure {

                    SecureField(placeholder, text: text)
                        .foregroundColor(.white)

                } else {

                    TextField(placeholder, text: text)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(
                            title == "Email Address" ? .never : .words
                        )
                        .autocorrectionDisabled()
                        .keyboardType(
                            title == "Email Address"
                            ? .emailAddress
                            : .default
                        )
                }
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {

                RoundedRectangle(cornerRadius: 13)
                    .stroke(
                        purple.opacity(0.5),
                        lineWidth: 1
                    )
            }
        }
    }

    // MARK: - Registration

    private func registerUser() {

        let success = authViewModel.signUp(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )

        if success {

            notificationMessage =
                "Account created successfully! Please log in."

            notificationSuccess = true

            showTopNotification()

            // Navigate back to Login after 2 seconds

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.0
            ) {
                dismiss()
            }

        } else {

            notificationMessage =
                authViewModel.errorMessage ?? "Registration failed."

            notificationSuccess = false

            showTopNotification()
        }
    }

    // MARK: - Notification Animation

    private func showTopNotification() {

        withAnimation(.spring(response: 0.4)) {
            showNotification = true
        }

        if !notificationSuccess {

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 3.0
            ) {
                withAnimation {
                    showNotification = false
                }
            }
        }
    }
}

#Preview {
    SignupView(authViewModel: AuthViewModel())
}
