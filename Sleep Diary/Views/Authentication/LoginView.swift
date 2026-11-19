import SwiftUI

struct LoginView: View {

    @StateObject private var authViewModel = AuthViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false

    private let purple = Color(
        red: 0.68,
        green: 0.32,
        blue: 1.0
    )

    private let darkPurple = Color(
        red: 0.10,
        green: 0.06,
        blue: 0.20
    )

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    .black,
                    darkPurple,
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            StarBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            Circle()
                .fill(purple.opacity(0.22))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .offset(x: -130, y: -250)

            Circle()
                .fill(Color.purple.opacity(0.20))
                .frame(width: 250, height: 250)
                .blur(radius: 100)
                .offset(x: 150, y: 250)

            ScrollView(showsIndicators: false) {

                VStack(spacing: 24) {

                    Spacer(minLength: 35)

                    // Logo

                    ZStack {

                        Circle()
                            .fill(purple.opacity(0.20))
                            .frame(width: 85, height: 85)
                            .blur(radius: 15)

                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, purple],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }

                    Text("Sleep Diary")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text("Welcome Back!")
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    Text("Track your sleep. Improve your life.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))

                    // Email

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Email")
                            .foregroundColor(.white)
                            .font(.subheadline)

                        HStack {

                            Image(systemName: "envelope")
                                .foregroundColor(purple)

                            TextField(
                                "Enter your email",
                                text: $email
                            )
                            .foregroundColor(.white)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    Color.white.opacity(0.15),
                                    lineWidth: 1
                                )
                        }
                    }

                    // Password

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Password")
                            .foregroundColor(.white)
                            .font(.subheadline)

                        HStack {

                            Image(systemName: "lock")
                                .foregroundColor(purple)

                            SecureField(
                                "Enter password",
                                text: $password
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    Color.white.opacity(0.15),
                                    lineWidth: 1
                                )
                        }
                    }

                    // Forgot Password Message

                    HStack {

                        Spacer()

                        Text("Use your registered email and password")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.55))
                    }

                    // Login Button

                    Button {

                        authViewModel.login(
                            email: email,
                            password: password
                        )

                    } label: {

                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        purple,
                                        Color(
                                            red: 0.48,
                                            green: 0.20,
                                            blue: 0.90
                                        )
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(
                                color: purple.opacity(0.35),
                                radius: 12
                            )
                    }

                    // Face ID

                    Button {

                        authViewModel.authenticate()

                    } label: {

                        Label(
                            "Login with Face ID",
                            systemImage: "faceid"
                        )
                        .font(.headline)
                        .foregroundColor(purple)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    purple.opacity(0.6),
                                    lineWidth: 1
                                )
                        }
                    }

                    // Sign Up Navigation

                    HStack(spacing: 5) {

                        Text("New to Sleep Diary?")
                            .foregroundColor(.white.opacity(0.7))

                        Button("Create Account") {
                            showSignup = true
                            authViewModel.errorMessage = nil
                        }
                        .foregroundColor(purple)
                        .fontWeight(.bold)
                    }
                    .font(.subheadline)

                    // Error Message

                    if let error = authViewModel.errorMessage {

                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }

                    Text("Your sleep. Your health. Your journey.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 15)

                    Spacer(minLength: 25)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 20)
            }
        }
        .preferredColorScheme(.dark)

        // Signup Screen

        .sheet(isPresented: $showSignup) {
            SignupView(authViewModel: authViewModel)
        }

        // Dashboard after successful login

        .fullScreenCover(
            isPresented: $authViewModel.isAuthenticated
        ) {
            DashboardView()
        }
    }
}

#Preview {
    LoginView()
}
