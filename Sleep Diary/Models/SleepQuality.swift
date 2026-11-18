//
//  SleepQuality.swift
//  MyApp
//
//  Created by KCEMAC8 on 14/11/26.
//

import Foundation

enum SleepQuality: String, CaseIterable, Codable {

    case poor = "Poor"
    case fair = "Fair"
    case good = "Good"
    case excellent = "Excellent"

    var emoji: String {
        switch self {
        case .poor:
            return "😴"
        case .fair:
            return "😐"
        case .good:
            return "😊"
        case .excellent:
            return "🌟"
        }
    }
}
