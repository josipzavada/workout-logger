//
//  WorkoutLogViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import SwiftUI

struct MaxInputViewModel {
    let title: String
    var value: Int?
}

struct WorkoutModeViewModel {
    let title: String
    let target: String?
    let workoutPreviews: [WorkoutPreviewViewModel]
}

struct WorkoutPreviewViewModel: Identifiable {
    let id = UUID().uuidString
    let target: String?
    let name: String
}

@MainActor
class NewWorkoutLogViewModel: ObservableObject {
    var workoutModeViewModel: WorkoutModeViewModel?
    @Published var workoutProgressLabel: String?
    @Published var workoutPlanItem: WorkoutPlanItem
    @Published var oneRepMax: Int?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?

    init(workoutPlanItem: WorkoutPlanItem) {
        self.workoutPlanItem = workoutPlanItem
        displayWorkout(for: workoutPlanItem.type)
    }

    private func displayWorkout(for type: WorkoutType) {
        switch type {
        case .pyramid:
            displayPyramidWorkout()
        case .emom:
            displayEmomWorkout()
        case .superset:
            displaySupersetWorkout()
        case .test:
            displayTestWorkout()
        }
    }

    private func displayPyramidWorkout() {
        guard let workout = workoutPlanItem.workouts.first else { return }
        workoutModeViewModel = WorkoutModeFormatter.formatPyramidWorkoutMode(workout: workout)
    }

    private func displayEmomWorkout() {
        workoutModeViewModel = WorkoutModeFormatter.formatEmomWorkoutMode(workouts: workoutPlanItem.workouts)
        workoutProgressLabel = Constants.WorkoutMode.emomWorkoutProgressLabel
    }

    private func displaySupersetWorkout() {
        workoutModeViewModel = WorkoutModeFormatter.formatSupersetWorkoutMode(workouts: workoutPlanItem.workouts)
        workoutProgressLabel = Constants.WorkoutMode.supersetsWorkoutProgressLabel
    }

    private func displayTestWorkout() {
        guard let workout = workoutPlanItem.workouts.first else { return }
        workoutModeViewModel = WorkoutModeFormatter.formatTestWorkoutMode(workout: workout)
    }

    func shouldShowOneRepMax(for workout: Workout) -> Bool {
        workout.sets.contains { set in
            if case .percentageOfMaximum = set.targetWeight {
                return true
            }
            return false
        }
    }

    func saveTapped() async {
        isLoading = true
        showError = false
        errorMessage = nil
        do {
            _ = try await NetworkService.shared.addWorkoutLog(workoutPlanItem: workoutPlanItem)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }
}
