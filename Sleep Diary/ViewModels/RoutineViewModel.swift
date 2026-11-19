import Foundation
import Combine

// MARK: - Routine ViewModel

class RoutineViewModel: ObservableObject {

    @Published var routines: [BedtimeRoutine] = []

    private let storageKey = "BedtimeRoutines"

    init() {
        loadRoutines()
    }

    // MARK: Add Routine

    func addRoutine(title: String, time: Date) {

        let newRoutine = BedtimeRoutine(
            title: title,
            time: time
        )

        routines.append(newRoutine)

        saveRoutines()
    }

    // MARK: Update Routine

    func updateRoutine(_ routine: BedtimeRoutine) {

        guard let index = routines.firstIndex(
            where: { $0.id == routine.id }
        ) else {
            return
        }

        routines[index] = routine

        saveRoutines()
    }

    // MARK: Delete Routine

    func deleteRoutine(at offsets: IndexSet) {

        for index in offsets.sorted(by: >) {

            if routines.indices.contains(index) {
                routines.remove(at: index)
            }
        }

        saveRoutines()
    }

    // MARK: Save Routines

    private func saveRoutines() {

        do {

            let data = try JSONEncoder().encode(routines)

            UserDefaults.standard.set(
                data,
                forKey: storageKey
            )

        } catch {

            print("Routine saving error: \(error.localizedDescription)")
        }
    }

    // MARK: Load Routines

    private func loadRoutines() {

        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }

        do {

            routines = try JSONDecoder().decode(
                [BedtimeRoutine].self,
                from: data
            )

        } catch {

            print("Routine loading error: \(error.localizedDescription)")
        }
    }
}
