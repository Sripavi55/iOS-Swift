import Foundation

class StorageService {

    private let storageKey = "SavedSleepEntries"

    // Save sleep entries
    func save(_ entries: [SleepEntry]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(entries)

            UserDefaults.standard.set(data, forKey: storageKey)

            print("Sleep entries saved successfully")

        } catch {
            print("Error saving sleep entries: \(error.localizedDescription)")
        }
    }

    // Load saved sleep entries
    func load() -> [SleepEntry] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            let entries = try decoder.decode([SleepEntry].self, from: data)

            return entries

        } catch {
            print("Error loading sleep entries: \(error.localizedDescription)")
            return []
        }
    }

    // Delete all sleep entries
    func deleteAll() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        print("All sleep entries deleted")
    }
}
