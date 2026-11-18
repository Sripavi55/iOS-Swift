import SwiftUI

struct SignupView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var message = ""
    @State private var showMessage = false

    private let purple = Color(
        red: 0.68,
        green: 0.32,
        blue: 1.0
    )

    var body: some View {

        ZStack {

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

            ScrollView(showsIndicators: false) {

                VStack(spacing: 22) {

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 55))
                        .foregroundColor(purple)
                        .shadow(color: purple, radius: 15)

                    Text("Create Account")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Start your better sleep journey")
                        .foregroundColor(.white.opacity(0.7))

                    inputField(
                        title: "Full Name",
                        placeholder: "Enter your name",
                        text: $name,
                        icon: "person"
                    )

                    inputField(
                        title: "Email Address",
                        placeholder: "Enter your email",
                        text: $email,
                        icon: "envelope"
                    )

                    inputField(
                        title: "Password",
                        placeholder: "Enter password",
                        text: $password,
                        icon: "lock",
                        isSecure: true
                    )

                    inputField(
                        title: "Confirm Password",
                        placeholder: "Confirm password",
                        text: $confirmPassword,
                        icon: "lock.fill",
                        isSecure: true
                    )

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
                    }

                    Button {
                        dismiss()
                    } label: {

                        HStack {

                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.7))

                            Text("Login")
                                .foregroundColor(purple)
                                .bold()
                        }
                    }
                }
                .padding(25)
            }
        }
        .preferredColorScheme(.dark)
        .alert("Registration", isPresented: $showMessage) {

            Button("OK", role: .cancel) { }

        } message: {

            Text(message)
        }
    }

    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String,
        isSecure: Bool = false
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
                        .keyboardType(
                            title == "Email Address" ? .emailAddress : .default
                        )
                }
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .stroke(purple.opacity(0.5), lineWidth: 1)
            }
        }
    }

    private func registerUser() {

        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {

            message = "Please fill in all fields."
            showMessage = true
            return
        }

        guard email.contains("@"),
              email.contains(".") else {

            message = "Please enter a valid email address."
            showMessage = true
            return
        }

        guard password.count >= 8 else {

            message = "Password must contain at least 8 characters."
            showMessage = true
            return
        }

        guard password == confirmPassword else {

            message = "Passwords do not match."
            showMessage = true
            return
        }

        // Registration validation completed.
        // Account storage and authentication will be connected next.

        message = "Registration details are valid!"
        showMessage = true
    }
}

#Preview {
    SignupView()
}
