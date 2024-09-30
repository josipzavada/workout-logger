//
//  ContentView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct NewWorkoutLogView: View {

    @StateObject private var viewModel = NewWorkoutLogViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let workoutPreviewViewModel = viewModel.workoutPreviewViewModel {
                        WorkoutModeView(viewModel: workoutPreviewViewModel)
                    }
                    ForEach(Array(viewModel.maxInputs.enumerated()), id: \.offset) { index, maxInputViewModel in
                        if let maxInputViewModel = maxInputViewModel {
                            WorkoutMaxInputView(title: maxInputViewModel.title, maxValue: $viewModel.workouts[index].oneRepMax)
                        }
                    }
                    ForEach(Array(viewModel.workouts.enumerated()), id: \.offset) { (index, workout) in

                        let workoutPathOrder: WorkoutPathOrder = workoutPathOrder(index: index, numberOfWorkouts: viewModel.workouts.count)

                        WorkoutInputView(
                            workoutName: workout.name,
                            valueUnit: workout.volumeUnit,
                            oneRepMax: $viewModel.workouts[index].oneRepMax,
                            workoutSetLogs: $viewModel.workouts[index].setLogs,
                            workoutPathOrder: viewModel.workoutProgressLabel != nil ? workoutPathOrder : .none,
                            workoutPathLabel: "\(viewModel.workoutProgressLabel ?? "")\(index + 1)"
                        )
                    }
                }
                .padding(12)
            }
            .scrollIndicators(.never)
            Button {
                viewModel.saveTapped()
            } label: {
                Text("Save")
            }
            .buttonStyle(WorkoutLogButton())

        }
        .background(Color(.Colors.paper))
        .navigationTitle("New log")
        .navigationBarTitleDisplayMode(.inline)
    }

    func workoutPathOrder(index: Int, numberOfWorkouts: Int) -> WorkoutPathOrder {
        if index == 0 {
            return WorkoutPathOrder.first
        } else if index == numberOfWorkouts - 1 {
            return WorkoutPathOrder.last
        } else {
            return WorkoutPathOrder.middle
        }
    }
}

#Preview {
    NewWorkoutLogView()
}
