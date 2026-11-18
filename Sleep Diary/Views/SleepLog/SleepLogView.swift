//
//  SleepLogView.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 18/11/26.
//

import SwiftUI

struct SleepLogView: View {

    @ObservedObject var viewModel: SleepViewModel

    @State private var searchText = ""
    @State private var selectedQuality: SleepQuality?

    private var filteredEntries: [SleepEntry] {

        var entries = viewModel.sleepEntries

        if !searchText.isEmpty {
            entries = entries.filter {
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let quality = selectedQuality {
            entries = entries.filter {
                $0.quality == quality
            }
        }

        return entries.sorted {
            $0.date > $1.date
        }
    }

    var body: some View {
        NavigationStack {
            VStack {

                Picker("Quality Filter", selection: $selectedQuality) {
                    Text("All").tag(nil as SleepQuality?)

                    ForEach(SleepQuality.allCases, id: \.self) { quality in
                        Text(quality.rawValue.capitalized)
                            .tag(quality as SleepQuality?)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)

                List {
                    ForEach(filteredEntries) { entry in
                        NavigationLink {
                            SleepDetailView(
                                viewModel: viewModel,
                                entry: entry
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {

                                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.headline)

                                Text(entry.quality.rawValue.capitalized)
                                    .foregroundColor(.secondary)

                                Text(entry.notes.isEmpty ? "No notes" : entry.notes)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete { offsets in
                        let entries = filteredEntries

                        for index in offsets {
                            viewModel.deleteEntry(entries[index])
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search sleep notes")
            }
            .navigationTitle("Sleep Log")
        }
    }
}
