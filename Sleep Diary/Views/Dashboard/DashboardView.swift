
import SwiftUI

struct DashboardView: View {

    @StateObject private var sleepViewModel = SleepViewModel()
    @StateObject private var dashboardViewModel = DashboardViewModel()

    @State private var showAddSleep = false

    // MARK: - Galaxy Purple Theme

    private let purple = Color(
        red: 0.72,
        green: 0.20,
        blue: 0.95
    )

    private let darkPurple = Color(
        red: 0.10,
        green: 0.05,
        blue: 0.20
    )

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: Background

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

                // MARK: Star Background

                StarBackground()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                // MARK: Main Scroll View

                ScrollView(.vertical, showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 25) {

                        // Header

                        VStack(alignment: .leading, spacing: 8) {

                            HStack {

                                VStack(alignment: .leading, spacing: 6) {

                                    Text("SLEEP DIARY")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .tracking(3)
                                        .foregroundColor(purple)

                                    Text("Good Morning!")
                                        .font(.system(
                                            size: 30,
                                            weight: .bold
                                        ))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                Image(systemName: "moon.stars.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(purple)
                                    .shadow(
                                        color: purple.opacity(0.8),
                                        radius: 15
                                    )
                            }

                            Text("Your sleep overview")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.65))
                        }

                        // MARK: Statistics Cards

                        HStack(spacing: 15) {

                            statisticCard(
                                title: "Total Nights",
                                value: "\(sleepViewModel.sleepEntries.count)",
                                icon: "moon.fill"
                            )

                            statisticCard(
                                title: "Average Sleep",
                                value: dashboardViewModel.averageSleepDuration,
                                icon: "clock.fill"
                            )
                        }

                        // MARK: Best Night

                        VStack(alignment: .leading, spacing: 15) {

                            HStack {

                                Image(systemName: "star.fill")
                                    .foregroundColor(purple)

                                Text("Your Best Night")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Spacer()
                            }

                            if let best = dashboardViewModel.bestNight {

                                Text(
                                    best.date.formatted(
                                        date: .long,
                                        time: .omitted
                                    )
                                )
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))

                                HStack {

                                    Text(best.quality.rawValue.capitalized)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(purple)

                                    Spacer()

                                    Image(systemName: "moon.zzz.fill")
                                        .font(.title)
                                        .foregroundColor(purple)
                                }

                            } else {

                                Text("No sleep records yet")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [
                                    purple.opacity(0.25),
                                    Color.white.opacity(0.04)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    purple.opacity(0.35),
                                    lineWidth: 1
                                )
                        }

                        // MARK: Recent Entries Header

                        HStack {

                            Text("Recent Entries")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Spacer()

                            NavigationLink {
                                SleepLogView(viewModel: sleepViewModel)
                            } label: {
                                Text("View All")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(purple)
                            }
                        }

                        // MARK: Recent Entries List

                        if dashboardViewModel.recentEntries.isEmpty {

                            VStack(spacing: 12) {

                                Image(systemName: "moon.zzz")
                                    .font(.system(size: 40))
                                    .foregroundColor(purple)

                                Text("No Sleep Records Yet")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Start tracking your sleep today.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(30)
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 18))

                        } else {

                            ForEach(dashboardViewModel.recentEntries) { entry in

                                NavigationLink {

                                    SleepDetailView(
                                        viewModel: sleepViewModel,
                                        entry: entry
                                    )

                                } label: {

                                    HStack(spacing: 15) {

                                        Image(systemName: "moon.stars.fill")
                                            .font(.title2)
                                            .foregroundColor(purple)
                                            .frame(width: 45, height: 45)
                                            .background(
                                                purple.opacity(0.15)
                                            )
                                            .clipShape(Circle())

                                        VStack(alignment: .leading, spacing: 6) {

                                            Text(
                                                entry.date.formatted(
                                                    date: .abbreviated,
                                                    time: .omitted
                                                )
                                            )
                                            .font(.headline)
                                            .foregroundColor(.white)

                                            Text(
                                                entry.quality.rawValue.capitalized
                                            )
                                            .font(.caption)
                                            .foregroundColor(purple)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding(15)
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                purple.opacity(0.20),
                                                Color.white.opacity(0.04)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                purple.opacity(0.20),
                                                lineWidth: 1
                                            )
                                    }
                                }
                            }
                        }

                        // MARK: Add Sleep Button

                        Button {

                            showAddSleep = true

                        } label: {

                            HStack {

                                Image(systemName: "plus.circle.fill")

                                Text("Add Sleep Entry")
                                    .fontWeight(.bold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        purple,
                                        Color(
                                            red: 0.45,
                                            green: 0.18,
                                            blue: 0.85
                                        )
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .shadow(
                                color: purple.opacity(0.3),
                                radius: 12
                            )
                        }

                        // MARK: Weekly Analysis Button

                        NavigationLink {

                            WeeklyAnalysisView(
                                viewModel: sleepViewModel
                            )

                        } label: {

                            HStack {

                                Image(systemName: "chart.bar.fill")

                                Text("View Weekly Analysis")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(purple)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(Color.white.opacity(0.06))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        purple.opacity(0.6),
                                        lineWidth: 1
                                    )
                            }
                        }

                        // Footer

                        Text("Your sleep. Your health. Your journey.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.45))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                            .padding(.bottom, 25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                }
            }
            .toolbar(.hidden, for: .navigationBar)

            // Add Sleep Sheet

            .sheet(isPresented: $showAddSleep) {

                AddSleepView(viewModel: sleepViewModel)
            }

            // Update Dashboard Data

            .onAppear {

                dashboardViewModel.updateEntries(
                    sleepViewModel.sleepEntries
                )
            }

            .onReceive(sleepViewModel.$sleepEntries) { entries in

                dashboardViewModel.updateEntries(entries)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Statistics Card

    private func statisticCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 15) {

            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(purple)
                .shadow(color: purple.opacity(0.5), radius: 8)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.65))

            Text(value)
                .font(.system(size: 21, weight: .bold))
                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    purple.opacity(0.22),
                    Color.white.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    purple.opacity(0.25),
                    lineWidth: 1
                )
        }
    }
}

// MARK: Star Background

struct StarBackground: View {

    var body: some View {

        GeometryReader { geometry in

            Canvas { context, size in

                for index in 0..<100 {

                    let x = CGFloat(
                        (index * 73 + 29) % 997
                    ) / 997 * size.width

                    let y = CGFloat(
                        (index * 137 + 41) % 991
                    ) / 991 * size.height

                    let starSize: CGFloat =
                        index % 5 == 0 ? 3 : 1.5

                    let rect = CGRect(
                        x: x,
                        y: y,
                        width: starSize,
                        height: starSize
                    )

                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(
                            .white.opacity(
                                index % 3 == 0 ? 0.8 : 0.35
                            )
                        )
                    )
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }
}

#Preview {
    DashboardView()
}

