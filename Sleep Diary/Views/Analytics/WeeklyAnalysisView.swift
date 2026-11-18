//
//  WeeklyAnalysisView.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 18/11/26.
//

import SwiftUI

struct WeeklyAnalysisView: View {

    @ObservedObject var viewModel: SleepViewModel

    private var weeklyEntries: [SleepEntry] {
        viewModel.sleepEntries.filter {
            Calendar.current.isDate(
                $0.date,
                equalTo: Date(),
                toGranularity: .weekOfYear
            )
        }
    }

    private var averageDuration: Double {
        guard !weeklyEntries.isEmpty else { return 0 }

        let total = weeklyEntries.reduce(0.0) {
            $0 + duration(for: $1)
        }

        return total / Double(weeklyEntries.count)
    }

    private var goodNights: Int {
        weeklyEntries.filter {
            $0.quality == .good || $0.quality == .excellent
        }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    Text("Your Weekly Sleep Report")
                        .font(.title2)
                        .bold()

                    analysisCard(
                        title: "Total Nights",
                        value: "\(weeklyEntries.count)",
                        icon: "moon.stars.fill"
                    )

                    analysisCard(
                        title: "Average Sleep",
                        value: String(format: "%.1f hours", averageDuration),
                        icon: "clock.fill"
                    )

                    analysisCard(
                        title: "Good / Excellent Nights",
                        value: "\(goodNights)",
                        icon: "star.fill"
                    )
                }
                .padding()
            }
            .navigationTitle("Weekly Analysis")
        }
    }

    private func analysisCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.blue)

            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.title2)
                    .bold()
            }

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }

    private func duration(for entry: SleepEntry) -> Double {
        var wake = entry.wakeUpTime

        if wake <= entry.bedtime {
            wake = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: wake
            ) ?? wake
        }

        return wake.timeIntervalSince(entry.bedtime) / 3600
    }
}
