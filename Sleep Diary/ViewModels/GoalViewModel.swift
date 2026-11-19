import Foundation
import Combine

class GoalViewModel: ObservableObject {

    @Published var targetHours: Double = 8.0

    private let storageKey = "SleepGoalHours"

    init() {
        loadGoal()
    }

    // MARK: - Update Goal

    func updateGoal(hours: Double) {
        targetHours = hours
        saveGoal()
    }

    // MARK: - Save Goal

    private func saveGoal() {
        UserDefaults.standard.set(
            targetHours,
            forKey: storageKey
        )
    }

    // MARK: - Load Goal

    private func loadGoal() {
        if UserDefaults.standard.object(forKey: storageKey) != nil {
            targetHours = UserDefaults.standard.double(
                forKey: storageKey
            )
        }
    }

    // MARK: - Goal Status

    var goalDescription: String {
        "\(targetHours.formatted(.number.precision(.fractionLength(1)))) hours per night"
    }
}
