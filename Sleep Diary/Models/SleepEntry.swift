//
//  SleepEntry.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 14/11/26.
//


import Foundation

struct SleepEntry: Identifiable, Codable,Equatable {

    var id = UUID()

    var date: Date

    var bedtime: Date

    var wakeUpTime: Date

    var quality: SleepQuality

    var notes: String

    var duration: Double {

        let calendar = Calendar.current

        var wake = wakeUpTime

        if wake <= bedtime {
            wake = calendar.date(
                byAdding: .day,
                value: 1,
                to: wakeUpTime
            ) ?? wakeUpTime
        }

        return wake.timeIntervalSince(bedtime) / 3600
    }
}
