import SwiftUI

struct LoginView: View {

    @StateObject private var authViewModel = AuthViewModel()

    @State private var email = ""
    @State private var password = ""

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

            // Background
            LinearGradient(
                colors: [
                    Color.black,
                    darkPurple,
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Background Glow
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

            VStack(spacing: 25) {

                Spacer()

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

                // App Name
                Text("Sleep Diary")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                Text("Welcome to Sleep Diary")
                    .font(.title3)
                    .foregroundColor(.white)

                Text("Track your sleep. Improve your life.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.65))

                Spacer()

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

                // Login Button
                Button {

                    authViewModel.manualLogin(
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
                                    Color(red: 0.48, green: 0.20, blue: 0.90)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: purple.opacity(0.35), radius: 12)
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
                            .stroke(purple.opacity(0.6), lineWidth: 1)
                    }
                }

                // Error
                if let error = authViewModel.errorMessage {

                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer()

                Text("Your sleep. Your health. Your journey.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
        }
        .preferredColorScheme(.dark)
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
