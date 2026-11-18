//
//  SleepDetilVew.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 18/11/26.
//

import SwiftUI

struct SleepDetailView: View {

    @ObservedObject var viewModel: SleepViewModel

    @State var entry: SleepEntry

    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = false

    private var duration: Double {
        var wake = entry.wakeUpTime

        if wake <= entry.bedtime {
            wake = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: wake
            ) ?? wake
        }

        return wake.timeIntervalSince(entry.bedtime) / 3600
    }

    var body: some View {
        Form {

            Section("Sleep Information") {

                Text(entry.date.formatted(date: .long, time: .omitted))

                DatePicker(
                    "Bedtime",
                    selection: $entry.bedtime,
                    displayedComponents: .hourAndMinute
                )
                .disabled(!isEditing)

                DatePicker(
                    "Wake Up Time",
                    selection: $entry.wakeUpTime,
                    displayedComponents: .hourAndMinute
                )
                .disabled(!isEditing)

                Text(String(format: "Duration: %.1f hours", duration))
            }

            Section("Sleep Quality") {
                Picker("Quality", selection: $entry.quality) {
                    ForEach(SleepQuality.allCases, id: \.self) { item in
                        Text(item.rawValue.capitalized)
                            .tag(item)
                    }
                }
                .disabled(!isEditing)
            }

            Section("Notes") {
                TextField("Notes", text: $entry.notes, axis: .vertical)
                    .disabled(!isEditing)
            }

            Section {
                if isEditing {
                    Button("Save Changes") {
                        viewModel.updateEntry(entry)
                        isEditing = false
                    }
                } else {
                    Button("Edit Entry") {
                        isEditing = true
                    }
                }

                Button("Delete Entry", role: .destructive) {
                    viewModel.deleteEntry(entry)
                    dismiss()
                }
            }
        }
        .navigationTitle("Sleep Details")
    }
}
