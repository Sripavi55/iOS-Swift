import SwiftUI

struct AddSleepView: View {

    @ObservedObject var viewModel: SleepViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()

    @State private var bedtime = Calendar.current.date(
        bySettingHour: 23,
        minute: 0,
        second: 0,
        of: Date()
    ) ?? Date()

    @State private var wakeUpTime = Calendar.current.date(
        bySettingHour: 7,
        minute: 0,
        second: 0,
        of: Date()
    ) ?? Date()

    @State private var quality: SleepQuality = .good
    @State private var notes = ""

    private let purple = Color(
        red: 0.68,
        green: 0.32,
        blue: 1.0
    )

    private let darkPurple = Color(
        red: 0.10,
        green: 0.05,
        blue: 0.20
    )

    // Calculate sleep duration

    private var sleepDuration: Double {

        var wake = wakeUpTime

        if wake <= bedtime {
            wake = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: wake
            ) ?? wake
        }

        return wake.timeIntervalSince(bedtime) / 3600
    }

    private var formattedDuration: String {

        let minutes = Int(sleepDuration * 60)

        return "\(minutes / 60)h \(minutes % 60)m"
    }

    var body: some View {

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

            // MARK: Purple Glow

            Circle()
                .fill(purple.opacity(0.20))
                .frame(width: 220, height: 220)
                .blur(radius: 90)
                .offset(x: 140, y: -300)
                .allowsHitTesting(false)

            // MARK: Main Content

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 25) {

                    // Header

                    HStack {

                        VStack(alignment: .leading, spacing: 8) {

                            Text("SLEEP DIARY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(3)
                                .foregroundColor(purple)

                            Text("Add Sleep")
                                .font(.system(
                                    size: 30,
                                    weight: .bold
                                ))
                                .foregroundColor(.white)

                            Text("Record your sleeping schedule")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.65))
                        }

                        Spacer()

                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 45))
                            .foregroundColor(purple)
                            .shadow(color: purple, radius: 15)
                    }
                    .padding(.top, 25)

                    // Sleep Date

                    dateSection

                    // Bedtime

                    timeSection(
                        title: "Bedtime",
                        icon: "moon.fill",
                        selection: $bedtime
                    )

                    // Wake Up Time

                    timeSection(
                        title: "Wake Up Time",
                        icon: "sun.max.fill",
                        selection: $wakeUpTime
                    )

                    // Sleep Duration

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Sleep Duration",
                            systemImage: "clock.fill"
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        HStack {

                            Image(systemName: "moon.zzz.fill")
                                .font(.system(size: 30))
                                .foregroundColor(purple)

                            VStack(alignment: .leading, spacing: 5) {

                                Text(formattedDuration)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)

                                Text("Automatically calculated")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }

                            Spacer()

                            Image(systemName: "sparkles")
                                .foregroundColor(purple)
                        }
                        .padding(18)
                        .background(purple.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(purple.opacity(0.5), lineWidth: 1)
                        }
                    }

                    // Sleep Quality

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Sleep Quality",
                            systemImage: "star.fill"
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        Picker("Sleep Quality", selection: $quality) {

                            ForEach(SleepQuality.allCases, id: \.self) {
                                item in

                                Text(item.rawValue.capitalized)
                                    .tag(item)
                            }
                        }
                        .tint(purple)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    // Notes

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Notes",
                            systemImage: "note.text"
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        TextField(
                            "Caffeine, late screen time, etc.",
                            text: $notes,
                            axis: .vertical
                        )
                        .lineLimit(3...5)
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    purple.opacity(0.4),
                                    lineWidth: 1
                                )
                        }
                    }

                    // Save Button

                    Button {

                        let entry = SleepEntry(
                            date: date,
                            bedtime: bedtime,
                            wakeUpTime: wakeUpTime,
                            quality: quality,
                            notes: notes
                        )

                        viewModel.addEntry(entry)

                        dismiss()

                    } label: {

                        Label(
                            "Save Sleep Entry",
                            systemImage: "checkmark.circle.fill"
                        )
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(
                            LinearGradient(
                                colors: [
                                    purple,
                                    Color.purple
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: purple.opacity(0.4), radius: 12)
                    }

                    // Cancel Button

                    Button {

                        dismiss()

                    } label: {

                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(purple)
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(purple, lineWidth: 1)
                            }
                    }

                    Text("Your sleep. Your health. Your journey.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 30)
                }
                .padding(.horizontal, 22)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Date Section

    private var dateSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Label(
                "Sleep Date",
                systemImage: "calendar"
            )
            .font(.headline)
            .foregroundColor(.white)

            DatePicker(
                "Select Date",
                selection: $date,
                displayedComponents: .date
            )
            .tint(purple)
            .padding(15)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    // MARK: Time Section

    private func timeSection(
        title: String,
        icon: String,
        selection: Binding<Date>
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.white)

            DatePicker(
                title,
                selection: selection,
                displayedComponents: .hourAndMinute
            )
            .tint(purple)
            .padding(15)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {

    AddSleepView(
        viewModel: SleepViewModel()
    )
}
