import SwiftUI

struct AddSleepView: View {

    @ObservedObject var viewModel: SleepViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var sleepDate = Date()
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

    @State private var notes = ""

    private let purple = Color(
        red: 0.72,
        green: 0.20,
        blue: 0.95
    )

    private var duration: Double {

        var wakeTime = wakeUpTime

        if wakeTime <= bedtime {
            wakeTime = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: wakeUpTime
            ) ?? wakeUpTime
        }

        return wakeTime.timeIntervalSince(bedtime) / 3600
    }

    private var sleepQuality: SleepQuality {
        SleepQuality.calculate(duration: duration)
    }

    private var durationText: String {

        let totalMinutes = Int(duration * 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return "\(hours)h \(minutes)m"
    }

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    .black,
                    Color(red: 0.10, green: 0.03, blue: 0.22),
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

                VStack(alignment: .leading, spacing: 22) {

                    Text("Add Sleep Entry")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Record your sleeping schedule")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))

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

                        Label("Sleep Duration", systemImage: "clock.fill")
                            .foregroundColor(.white)
                            .font(.headline)

                        HStack {

                            Image(systemName: "moon.zzz.fill")
                                .font(.title2)
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 5) {

                                Text(durationText)
                                    .font(.title.bold())
                                    .foregroundColor(.white)

                                Text("Automatically calculated")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            Image(systemName: "sparkles")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [
                                    purple,
                                    Color.purple.opacity(0.55)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                    }

                    // Automatic Sleep Quality

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Sleep Quality",
                            systemImage: "star.fill"
                        )
                        .foregroundColor(.white)
                        .font(.headline)

                        HStack {

                            VStack(alignment: .leading, spacing: 7) {

                                Text(sleepQuality.displayName)
                                    .font(.title3.bold())
                                    .foregroundColor(.white)

                                Text(sleepQuality.recommendation)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.75))
                            }

                            Spacer()

                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundColor(purple)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    purple.opacity(0.6),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(16)

                        Text("Sleep quality is automatically estimated from your sleep duration.")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.55))
                    }

                    // Notes

                    VStack(alignment: .leading, spacing: 10) {

                        Label("Notes", systemImage: "note.text")
                            .foregroundColor(.white)
                            .font(.headline)

                        TextField(
                            "Caffeine, late screen time, etc.",
                            text: $notes,
                            axis: .vertical
                        )
                        .lineLimit(3...5)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(14)
                    }

                    // Save Button

                    Button {

                        let entry = SleepEntry(
                            date: sleepDate,
                            bedtime: bedtime,
                            wakeUpTime: wakeUpTime,
                            quality: sleepQuality,
                            notes: notes
                        )

                        viewModel.addEntry(entry)

                        dismiss()

                    } label: {

                        Text("Save Sleep Entry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        purple,
                                        Color.purple.opacity(0.65)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }

                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Date Section

    private var dateSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label("Sleep Date", systemImage: "calendar")
                .foregroundColor(.white)
                .font(.headline)

            DatePicker(
                "Select Date",
                selection: $sleepDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .tint(.purple)
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(14)
            .foregroundColor(.white)
        }
    }

    // MARK: Time Section

    private func timeSection(
        title: String,
        icon: String,
        selection: Binding<Date>
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(title, systemImage: icon)
                .foregroundColor(.white)
                .font(.headline)

            DatePicker(
                title,
                selection: selection,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.compact)
            .tint(.purple)
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(14)
            .foregroundColor(.white)
        }
    }
}
