//
//  WorkoutLogViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

class WorkoutLogViewModel {
    var workoutModeViewModel: WorkoutModeViewModel?
    var workoutProgressLabel: String?
    var workouts: [Workout] = []

    init(workoutPlanItem: WorkoutPlanItem) {
        displayWorkout(for: workoutPlanItem)
    }

    private func displayWorkout(for workoutPlanItem: WorkoutPlanItem) {
        switch workoutPlanItem.type {
        case .pyramid:
            displayPyramidWorkout(workoutPlanItem: workoutPlanItem)
        case .emom:
            displayEmomWorkout(workoutPlanItem: workoutPlanItem)
        case .superset:
            displaySupersetWorkout(workoutPlanItem: workoutPlanItem)
        case .test:
            displayTestWorkout(workoutPlanItem: workoutPlanItem)
        }
    }

    private func displayPyramidWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workoutModeViewModel = WorkoutModeFormatter.formatPyramidWorkoutMode(workout: workout)
        workouts = [workout]
    }

    private func displayEmomWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatEmomWorkoutMode(workouts: workoutPlanItem.workouts)
        workouts = workoutPlanItem.workouts
        workoutProgressLabel = Constants.WorkoutMode.emomWorkoutProgressLabel
    }

    private func displaySupersetWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatSupersetWorkoutMode(workouts: workoutPlanItem.workouts)
        workouts = workoutPlanItem.workouts
        workoutProgressLabel = Constants.WorkoutMode.supersetsWorkoutProgressLabel
    }

    private func displayTestWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workouts = [workout]
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
}
