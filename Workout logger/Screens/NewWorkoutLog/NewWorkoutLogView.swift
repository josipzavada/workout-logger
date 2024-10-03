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
                    workoutModeView
                    oneRepMaxInputs
                    workoutInputs
                }
                .padding(12)
            }
            .scrollIndicators(.hidden)
            .dismissKeyboardOnTap()

            saveButton
        }
        .background(Color(.Colors.paper))
        .navigationTitle(Constants.WorkoutLog.newLog)
        .navigationBarTitleDisplayMode(.inline)
        .alert(Constants.General.error, isPresented: $viewModel.showError, presenting: viewModel.errorMessage) { _ in
            Button(Constants.General.ok) {
                viewModel.showError = false
            }
        } message: { errorMessage in
            Text(errorMessage)
        }
    }
    
    @ViewBuilder
    private var workoutModeView: some View {
        if let workoutPreviewViewModel = viewModel.workoutModeViewModel {
            WorkoutModeView(viewModel: workoutPreviewViewModel)
        }
    }
    
    private var oneRepMaxInputs: some View {
        ForEach(Array(viewModel.workoutPlanItem.workouts.enumerated()), id: \.offset) { index, workout in
            if viewModel.shouldShowOneRepMax(for: workout) {
                WorkoutMaxInputView(title: workout.name, maxValue: $viewModel.workoutPlanItem.workouts[index].oneRepMax)
            }
        }
    }
    
    private var workoutInputs: some View {
        ForEach(Array(viewModel.workoutPlanItem.workouts.enumerated()), id: \.offset) { (index, workout) in
            WorkoutInputView(
                workoutName: workout.name,
                volumeUnit: workout.volumeUnit,
                workout: $viewModel.workoutPlanItem.workouts[index],
                isLastInWorkoutPath: isLastInWorkoutPath(for: index),
                workoutPathLabel: "\(viewModel.workoutProgressLabel ?? "")\(index + 1)"
            )
        }
    }
    
    private func isLastInWorkoutPath(for index: Int) -> Bool? {
        viewModel.workoutProgressLabel != nil
            ? WorkoutModeFormatter.isLastInWorkoutPath(index: index, numberOfWorkouts: viewModel.workoutPlanItem.workouts.count)
            : nil
    }
    
    private var saveButton: some View {
        Button {
            Task {
                await viewModel.saveTapped()
                if !viewModel.showError {
                    navigationPathModel.shouldRefreshWorkoutLogs = true
                    navigationPathModel.path.removeLast()
                }
            }
        } label: {
            if viewModel.isLoading {
                ProgressView().tint(.white)
            } else {
                Text(Constants.General.save)
            }
        }
        .buttonStyle(WorkoutLogButton())
    }
}

//#Preview {
//    NewWorkoutLogView()
//}
