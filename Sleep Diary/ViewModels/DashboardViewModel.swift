//
//  DashboardViewModel.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 14/11/26.
//

import Foundation
import Combine

class DashboardViewModel: ObservableObject {

    @Published var sleepEntries: [SleepEntry] = []

    var totalNights: Int {
        sleepEntries.count
    }

    var averageSleepDuration: String {

        guard !sleepEntries.isEmpty else {
            return "0h 0m"
        }

        let total = sleepEntries.reduce(0.0) {
            $0 + durationInHours(for: $1)
        }

        let average = total / Double(sleepEntries.count)

        let hours = Int(average)
        let minutes = Int((average - Double(hours)) * 60)

        return "\(hours)h \(minutes)m"
    }

    var bestNight: SleepEntry? {
        sleepEntries.max {
            durationInHours(for: $0) < durationInHours(for: $1)
        }
    }

    var recentEntries: [SleepEntry] {
        Array(
            sleepEntries.sorted {
                $0.date > $1.date
            }.prefix(5)
        )
    }

    func updateEntries(_ entries: [SleepEntry]) {
        sleepEntries = entries
    }

    private func durationInHours(for entry: SleepEntry) -> Double {

        var wakeUp = entry.wakeUpTime

        if wakeUp <= entry.bedtime {
            wakeUp = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: wakeUp
            ) ?? wakeUp
        }

        return wakeUp.timeIntervalSince(entry.bedtime) / 3600
    }
}
