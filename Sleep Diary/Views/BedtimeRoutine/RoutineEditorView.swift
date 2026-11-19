//
//  RoutineEditorView.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 19/11/26.
//

import SwiftUI

struct RoutineEditorView: View {

    @ObservedObject var viewModel: RoutineViewModel

    @Environment(\.dismiss) private var dismiss

    var routine: BedtimeRoutine?

    @State private var title = ""
    @State private var selectedTime = Date()

    @State private var showAlert = false

    private let purple = Color(
        red: 0.72,
        green: 0.20,
        blue: 0.95
    )

    private let darkPurple = Color(
        red: 0.10,
        green: 0.05,
        blue: 0.20
    )

    init(
        viewModel: RoutineViewModel,
        routine: BedtimeRoutine? = nil
    ) {
        self.viewModel = viewModel
        self.routine = routine

        _title = State(initialValue: routine?.title ?? "")
        _selectedTime = State(initialValue: routine?.time ?? Date())
    }

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color.black,
                    darkPurple,
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            StarBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            ScrollView {

                VStack(spacing: 25) {

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 55))
                        .foregroundColor(purple)
                        .shadow(color: purple, radius: 15)

                    Text(routine == nil ? "Create Routine" : "Edit Routine")
                        .font(.title.bold())
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Routine Name")
                            .foregroundColor(.white)

                        TextField(
                            "Example: Brush your teeth",
                            text: $title
                        )
                        .padding()
                        .background(darkPurple)
                        .cornerRadius(12)
                        .foregroundColor(.white)

                        Text("Select Time")
                            .foregroundColor(.white)

                        DatePicker(
                            "Routine Time",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .frame(maxWidth: .infinity)
                        .background(darkPurple)
                        .cornerRadius(15)
                    }

                    Button {
                        saveRoutine()
                    } label: {

                        Text(routine == nil ? "Save Routine" : "Update Routine")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        purple,
                                        darkPurple
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                    }

                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                .padding(25)
            }
        }
        .preferredColorScheme(.dark)
        .alert("Routine Name Required", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a name for your bedtime routine.")
        }
    }

    private func saveRoutine() {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty else {
            showAlert = true
            return
        }

        if let existingRoutine = routine {

            let updatedRoutine = BedtimeRoutine(
                id: existingRoutine.id,
                title: cleanTitle,
                time: selectedTime
            )

            viewModel.updateRoutine(updatedRoutine)

        } else {

            viewModel.addRoutine(
                title: cleanTitle,
                time: selectedTime
            )
        }

        dismiss()
    }
}
