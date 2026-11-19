import SwiftUI
import Charts

struct WeeklyAnalysisView: View {

    @StateObject private var sleepViewModel = SleepViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPeriod = "Daily"

    private let periods = ["Daily", "Weekly", "Monthly"]

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

    private struct SleepChartData: Identifiable {
        let id = UUID()
        let date: Date
        let hours: Double
    }

    // MARK: - Calendar

    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 1
        return cal
    }

    // MARK: - Calculate Sleep Duration

    private func durationInHours(for entry: SleepEntry) -> Double {

        var wakeUp = entry.wakeUpTime

        if wakeUp <= entry.bedtime {
            wakeUp = calendar.date(
                byAdding: .day,
                value: 1,
                to: wakeUp
            ) ?? wakeUp
        }

        return max(
            0,
            wakeUp.timeIntervalSince(entry.bedtime) / 3600
        )
    }

    private func averageDuration(
        _ entries: [SleepEntry]
    ) -> Double {

        guard !entries.isEmpty else {
            return 0
        }

        let total = entries.reduce(0.0) {
            $0 + durationInHours(for: $1)
        }

        return total / Double(entries.count)
    }

    // MARK: - Daily Data

    private var dailyData: [SleepChartData] {

        let today = calendar.startOfDay(for: Date())

        guard let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: today
        ) else {
            return []
        }

        let entries = sleepViewModel.sleepEntries.filter {
            $0.date >= today && $0.date < tomorrow
        }

        return [
            SleepChartData(
                date: today,
                hours: averageDuration(entries)
            )
        ]
    }

    // MARK: - Weekly Data (Sunday to Saturday)

    private var weeklyData: [SleepChartData] {

        let today = calendar.startOfDay(for: Date())

        guard let weekStart = calendar.dateInterval(
            of: .weekOfYear,
            for: today
        )?.start else {
            return []
        }

        return (0..<7).compactMap { index in

            guard let day = calendar.date(
                byAdding: .day,
                value: index,
                to: weekStart
            ),
            let nextDay = calendar.date(
                byAdding: .day,
                value: 1,
                to: day
            ) else {
                return nil
            }

            let entries = sleepViewModel.sleepEntries.filter {
                $0.date >= day && $0.date < nextDay
            }

            return SleepChartData(
                date: day,
                hours: averageDuration(entries)
            )
        }
    }

    // MARK: - Monthly Data (Current + Previous 4 Months)

    private var monthlyData: [SleepChartData] {

        let today = calendar.startOfDay(for: Date())

        guard let currentMonth = calendar.dateInterval(
            of: .month,
            for: today
        )?.start else {
            return []
        }

        return (0..<5).reversed().compactMap { offset in

            guard let monthStart = calendar.date(
                byAdding: .month,
                value: -offset,
                to: currentMonth
            ),
            let nextMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: monthStart
            ) else {
                return nil
            }

            let entries = sleepViewModel.sleepEntries.filter {
                $0.date >= monthStart && $0.date < nextMonth
            }

            return SleepChartData(
                date: monthStart,
                hours: averageDuration(entries)
            )
        }
    }

    // MARK: - Selected Data

    private var chartData: [SleepChartData] {

        switch selectedPeriod {

        case "Daily":
            return dailyData

        case "Weekly":
            return weeklyData

        default:
            return monthlyData
        }
    }

    // MARK: - Correct Average

    private var displayedAverage: Double {

        switch selectedPeriod {

        case "Daily":
            return dailyData.first?.hours ?? 0

        case "Weekly":

            guard let firstDay = weeklyData.first?.date,
                  let nextWeek = calendar.date(
                    byAdding: .day,
                    value: 7,
                    to: firstDay
                  ) else {
                return 0
            }

            let entries = sleepViewModel.sleepEntries.filter {
                $0.date >= firstDay && $0.date < nextWeek
            }

            return averageDuration(entries)

        default:

            guard let firstMonth = monthlyData.first?.date,
                  let nextMonth = calendar.date(
                    byAdding: .month,
                    value: 5,
                    to: firstMonth
                  ) else {
                return 0
            }

            let entries = sleepViewModel.sleepEntries.filter {
                $0.date >= firstMonth && $0.date < nextMonth
            }

            return averageDuration(entries)
        }
    }

    // MARK: - Date Labels

    private func axisDateLabel(_ date: Date) -> String {

        let formatter = DateFormatter()

        switch selectedPeriod {

        case "Daily":
            formatter.dateFormat = "dd MMM"

        case "Weekly":
            formatter.dateFormat = "EEE"

        default:
            formatter.dateFormat = "MMM yy"
        }

        return formatter.string(from: date)
    }

    // MARK: - Chart

    private var sleepChart: some View {

        Chart {

            ForEach(chartData) { item in

                if selectedPeriod == "Daily" {

                    BarMark(
                        x: .value("Date", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(purple.gradient)
                    .cornerRadius(9)

                } else if selectedPeriod == "Weekly" {

                    BarMark(
                        x: .value("Day", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(purple.gradient)
                    .cornerRadius(6)

                    PointMark(
                        x: .value("Day", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(.white)
                    .symbolSize(35)

                } else {

                    AreaMark(
                        x: .value("Month", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                purple.opacity(0.45),
                                purple.opacity(0.03)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    LineMark(
                        x: .value("Month", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(purple)
                    .lineStyle(
                        StrokeStyle(lineWidth: 3)
                    )

                    PointMark(
                        x: .value("Month", item.date),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(.white)
                    .symbolSize(55)
                }
            }
        }
        .chartYScale(domain: 0...12)

        .chartXAxis {

            AxisMarks(values: chartData.map { $0.date }) { value in

                AxisGridLine()
                    .foregroundStyle(.white.opacity(0.12))

                AxisTick()
                    .foregroundStyle(.white.opacity(0.4))

                AxisValueLabel {

                    if let date = value.as(Date.self) {
                        Text(axisDateLabel(date))
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }

        // FIXED: Added the required closure argument here.

        .chartYAxis {

            AxisMarks(position: .leading) { _ in

                AxisGridLine()
                    .foregroundStyle(.white.opacity(0.12))

                AxisValueLabel()
                    .foregroundStyle(.white.opacity(0.7))
            }
        }

        .frame(height: 230)
        .padding(.horizontal, 5)
    }

    // MARK: - Sleep Tip

    private var sleepTip: String {

        let average = displayedAverage

        if average == 0 {
            return "Start recording your sleep to discover your sleeping pattern."
        } else if average < 6 {
            return "Your sleep duration is quite low. Try adding 30–60 minutes to your sleep tonight."
        } else if average < 7 {
            return "You're getting closer! Try sleeping a little earlier."
        } else if average <= 9 {
            return "Great progress! Keep following your regular sleep schedule."
        } else {
            return "Your sleep duration is above the usual recommended range. Maintain a consistent sleep routine."
        }
    }

    // MARK: - Main View

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

            ScrollView(showsIndicators: false) {

                VStack(spacing: 22) {

                    // Header

                    HStack {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                                .foregroundColor(purple)
                        }

                        Spacer()

                        Text("Sleep Analytics")
                            .font(.headline.bold())
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "chart.xyaxis.line")
                            .font(.title2)
                            .foregroundColor(purple)
                    }
                    .padding(.top, 10)

                    // Title

                    VStack(alignment: .leading, spacing: 7) {

                        Text("Your Sleep Report")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text("Understand your sleeping patterns")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Period Buttons

                    HStack(spacing: 8) {

                        ForEach(periods, id: \.self) { period in

                            Button {

                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedPeriod = period
                                }

                            } label: {

                                Text(period)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 13)
                                    .background(
                                        selectedPeriod == period
                                        ? purple
                                        : Color.purple.opacity(0.25)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 13)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Chart Card

                    VStack(alignment: .leading, spacing: 16) {

                        Text(
                            selectedPeriod == "Daily"
                            ? "Today's Sleep Duration"
                            : selectedPeriod == "Weekly"
                            ? "Weekly Sleep Duration"
                            : "Monthly Sleep Duration"
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        HStack(alignment: .firstTextBaseline, spacing: 8) {

                            Text(
                                String(format: "%.1f", displayedAverage)
                            )
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                            Text("hours average")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }

                        sleepChart

                        Text(
                            selectedPeriod == "Daily"
                            ? "Today's recorded sleep"
                            : selectedPeriod == "Weekly"
                            ? "Sunday – Saturday"
                            : "Last five months"
                        )
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.55))
                        .frame(maxWidth: .infinity)
                    }
                    .padding(18)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.25, green: 0.05, blue: 0.55),
                                Color(red: 0.12, green: 0.04, blue: 0.28)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 23)
                    )
                    .overlay {

                        RoundedRectangle(cornerRadius: 23)
                            .stroke(
                                purple.opacity(0.65),
                                lineWidth: 1
                            )
                    }
                    .shadow(
                        color: purple.opacity(0.18),
                        radius: 15
                    )

                    // Sleep Tip

                    HStack(alignment: .top, spacing: 13) {

                        Image(systemName: "lightbulb.fill")
                            .font(.title2)
                            .foregroundColor(purple)

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Sleep Tip")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(sleepTip)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(17)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.20))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .overlay {

                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                purple.opacity(0.35),
                                lineWidth: 1
                            )
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeeklyAnalysisView()
}
