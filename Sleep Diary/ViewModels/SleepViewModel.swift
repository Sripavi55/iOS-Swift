//
//  SleepViewModel.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 14/11/26.
//
import Foundation
import Combine

class SleepViewModel: ObservableObject {

    @Published var sleepEntries: [SleepEntry] = []

    private let storageService = StorageService()

    init() {
        loadEntries()
    }

    // Load Entries
    func loadEntries() {
        sleepEntries = storageService.load()

        sleepEntries.sort {
            $0.date > $1.date
        }
    }

    // Add Sleep Entry
    func addEntry(_ entry: SleepEntry) {
        sleepEntries.append(entry)

        sleepEntries.sort {
            $0.date > $1.date
        }

        saveEntries()
    }

    // Update Sleep Entry
    func updateEntry(_ updatedEntry: SleepEntry) {

        if let index = sleepEntries.firstIndex(
            where: { $0.id == updatedEntry.id }
        ) {
            sleepEntries[index] = updatedEntry
            saveEntries()
        }
    }

    // Delete Sleep Entry
    func deleteEntry(_ entry: SleepEntry) {

        sleepEntries.removeAll {
            $0.id == entry.id
        }

        saveEntries()
    }

    // Search Entries
    func searchEntries(query: String) -> [SleepEntry] {

        guard !query.isEmpty else {
            return sleepEntries
        }

        return sleepEntries.filter {
            $0.notes.localizedCaseInsensitiveContains(query)
        }
    }

    // Filter by Sleep Quality
    func filterByQuality(quality: SleepQuality) -> [SleepEntry] {

        return sleepEntries.filter {
            $0.quality == quality
        }
    }

    // Save Entries
    private func saveEntries() {
        storageService.save(sleepEntries)
    }
}
