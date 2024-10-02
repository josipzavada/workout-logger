//
//  ContentView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct NewWorkoutLogView: View {

    @ObservedObject var viewModel: NewWorkoutLogViewModel
    @EnvironmentObject var navigationPathModel: NavigationPathModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let workoutPreviewViewModel = viewModel.workoutModeViewModel {
                        WorkoutModeView(viewModel: workoutPreviewViewModel)
                    }
                    ForEach(Array(viewModel.workoutPlanItem.workouts.enumerated()), id: \.offset) { index, workout in
                        if viewModel.shouldShowOneRepMax(for: workout) {
                            WorkoutMaxInputView(title: workout.name, maxValue: $viewModel.workoutPlanItem.workouts[index].oneRepMax)
                        }
                    }
                    ForEach(Array(viewModel.workoutPlanItem.workouts.enumerated()), id: \.offset) { (index, workout) in

                        let workoutPathOrder: WorkoutPathOrder = WorkoutModeFormatter.workoutPathOrder(index: index, numberOfWorkouts: viewModel.workoutPlanItem.workouts.count)

                        WorkoutInputView(
                            workoutName: workout.name,
                            valueUnit: workout.volumeUnit,
                            oneRepMax: $viewModel.workoutPlanItem.workouts[index].oneRepMax,
                            workoutSets: $viewModel.workoutPlanItem.workouts[index].sets,
                            workoutPathOrder: viewModel.workoutProgressLabel != nil ? workoutPathOrder : .none,
                            workoutPathLabel: "\(viewModel.workoutProgressLabel ?? "")\(index + 1)"
                        )
                    }
                }
                .padding(12)
            }
            .scrollIndicators(.never)
            Button {
                Task {
                    await viewModel.saveTapped()
                    if !viewModel.showError {
                        navigationPathModel.path.removeLast()
                    }
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save")
                }
            }
            .buttonStyle(WorkoutLogButton())

        }
        .background(Color(.Colors.paper))
        .navigationTitle("New log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NewWorkoutLogView()
//}
