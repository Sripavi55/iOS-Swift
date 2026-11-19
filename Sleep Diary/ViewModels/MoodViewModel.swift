import Foundation
import Combine

// MARK: - Mood Record Model

struct MoodRecord: Identifiable, Codable {

    var id: UUID
    var mood: String
    var energyLevel: Double
    var notes: String
    var date: Date

    init(
        id: UUID = UUID(),
        mood: String,
        energyLevel: Double,
        notes: String,
        date: Date = Date()
    ) {
        self.id = id
        self.mood = mood
        self.energyLevel = energyLevel
        self.notes = notes
        self.date = date
    }
}

// MARK: - Mood ViewModel

class MoodViewModel: ObservableObject {

    @Published var moodEntries: [MoodRecord] = []

    private let storageKey = "MoodEntries"

    init() {
        loadMoods()
    }

    // MARK: Add Mood

    func addMood(
        mood: String,
        energyLevel: Double,
        notes: String
    ) {

        let newEntry = MoodRecord(
            mood: mood,
            energyLevel: energyLevel,
            notes: notes
        )

        moodEntries.insert(newEntry, at: 0)

        saveMoods()
    }

    // MARK: Delete Mood

    func deleteMood(at offsets: IndexSet) {

        for index in offsets.sorted(by: >) {

            if moodEntries.indices.contains(index) {
                moodEntries.remove(at: index)
            }
        }

        saveMoods()
    }

    // MARK: Save Moods

    private func saveMoods() {

        do {

            let data = try JSONEncoder().encode(moodEntries)

            UserDefaults.standard.set(
                data,
                forKey: storageKey
            )

        } catch {

            print("Mood saving error: \(error.localizedDescription)")
        }
    }

    // MARK: Load Moods

    private func loadMoods() {

        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }

        do {

            moodEntries = try JSONDecoder().decode(
                [MoodRecord].self,
                from: data
            )

        } catch {

            print("Mood loading error: \(error.localizedDescription)")
        }
    }
}
