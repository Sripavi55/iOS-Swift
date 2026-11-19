import Foundation

enum SleepQuality: String, CaseIterable, Codable {

    case poor
    case fair
    case good
    case excellent

    var displayName: String {
        switch self {
        case .poor:
            return "You Need More Rest! 🌙"

        case .fair:
            return "Almost There! ✨"

        case .good:
            return "You're Doing Great! 💜"

        case .excellent:
            return "Time to Recharge! 🌟"
        }
    }

    var recommendation: String {
        switch self {
        case .poor:
            return "Your sleep was shorter than recommended. Try going to bed earlier and give your body more rest tonight."

        case .fair:
            return "You're getting closer! Try adding 30–60 minutes of sleep to your routine."

        case .good:
            return "Amazing! You're getting a healthy amount of sleep. Keep following your regular sleep schedule."

        case .excellent:
            return "You've slept longer than your usual target. Listen to your body and maintain a consistent sleep routine."
        }
    }

    static func calculate(duration: Double) -> SleepQuality {

        if duration < 6 {
            return .poor

        } else if duration < 7 {
            return .fair

        } else if duration <= 9 {
            return .good

        } else {
            return .excellent
        }
    }
}
