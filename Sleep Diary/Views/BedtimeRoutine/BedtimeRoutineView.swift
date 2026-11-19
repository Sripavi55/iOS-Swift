//
//  BedtimeRoutineView.swift
//  Sleep Diary
//
//  Created by KCEMAC8 on 19/11/26.
//

import SwiftUI

struct BedtimeRoutineView: View {

    @StateObject private var viewModel = RoutineViewModel()
    @State private var showEditor = false

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

    var body: some View {

        NavigationStack {

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

                    VStack(alignment: .leading, spacing: 22) {

                        // Header

                        VStack(alignment: .leading, spacing: 8) {

                            Text("BEDTIME ROUTINE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .tracking(3)
                                .foregroundColor(purple)

                            Text("Prepare for Better Sleep")
                                .font(.system(
                                    size: 27,
                                    weight: .bold
                                ))
                                .foregroundColor(.white)

                            Text("Build healthy habits before bedtime.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.65))
                        }

                        // Add Routine Button

                        Button {
                            showEditor = true
                        } label: {

                            HStack {

                                Image(systemName: "plus.circle.fill")

                                Text("Add New Routine")

                                Spacer()

                                Image(systemName: "arrow.right")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
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
                            .cornerRadius(16)
                        }

                        // Routine List

                        Text("Your Daily Routine")
                            .font(.title3.bold())
                            .foregroundColor(.white)

                        if viewModel.routines.isEmpty {

                            VStack(spacing: 12) {

                                Image(systemName: "moon.stars.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(purple)

                                Text("No routines added yet")
                                    .foregroundColor(.white)

                                Text("Create your first bedtime routine.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(30)
                            .background(darkPurple.opacity(0.8))
                            .cornerRadius(18)

                        } else {

                            ForEach(viewModel.routines) { routine in

                                NavigationLink {
                                    RoutineEditorView(
                                        viewModel: viewModel,
                                        routine: routine
                                    )
                                } label: {

                                    HStack(spacing: 15) {

                                        Image(systemName: "moon.zzz.fill")
                                            .font(.title2)
                                            .foregroundColor(purple)

                                        VStack(alignment: .leading, spacing: 5) {

                                            Text(routine.title)
                                                .font(.headline)
                                                .foregroundColor(.white)

                                            Text(routine.time, style: .time)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.65))
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(purple)
                                    }
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [
                                                darkPurple,
                                                purple.opacity(0.25)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                                }
                            }
                            .onDelete(perform: viewModel.deleteRoutine)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .principal) {
                    Text("Sleep Diary")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .foregroundColor(purple)
                }
            }
            .sheet(isPresented: $showEditor) {
                RoutineEditorView(viewModel: viewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}
