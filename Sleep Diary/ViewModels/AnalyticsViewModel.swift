//
//  AnalyticsViewModel.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 18/11/26.
//

import Foundation
import Combine

class AnalyticsViewModel: ObservableObject {

    @Published var totalNights: Int = 0
    @Published var averageSleep: String = "0h 0m"
    @Published var bestSleep: String = "0h 0m"
    @Published var weeklyAverage: String = "0h 0m"
    @Published var goodNights: Int = 0

    // MARK: - Calculate Analytics

    func calculateAnalytics(entries: [SleepEntry]) {

        totalNights = entries.count

        guard !entries.isEmpty else {
            averageSleep = "0h 0m"
            bestSleep = "0h 0m"
            weeklyAverage = "0h 0m"
            goodNights = 0
            return
        }

        let totalDuration = entries.reduce(0.0) {
            $0 + $1.duration
        }

        let average = totalDuration / Double(entries.count)

        averageSleep = formatDuration(average)

        let best = entries.map { $0.duration }.max() ?? 0

        bestSleep = formatDuration(best)

        // Weekly calculation

        let calendar = Calendar.current

        let weeklyEntries = entries.filter {
            calendar.isDate(
                $0.date,
                equalTo: Date(),
                toGranularity: .weekOfYear
            )
        }

        if !weeklyEntries.isEmpty {

            let weeklyTotal = weeklyEntries.reduce(0.0) {
                $0 + $1.duration
            }

            let weeklyAvg = weeklyTotal /
                Double(weeklyEntries.count)

            weeklyAverage = formatDuration(weeklyAvg)

        } else {
            weeklyAverage = "0h 0m"
        }

        // Good and Excellent nights

        goodNights = entries.filter {
            $0.quality == .good ||
            $0.quality == .excellent
        }.count
    }

    // MARK: - Format Duration

    private func formatDuration(_ duration: Double) -> String {

        let hours = Int(duration)
        let minutes = Int((duration - Double(hours)) * 60)

        return "\(hours)h \(minutes)m"
    }
}
