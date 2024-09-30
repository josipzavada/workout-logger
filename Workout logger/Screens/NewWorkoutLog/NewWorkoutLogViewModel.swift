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
    var id = UUID().uuidString
    let target: String?
    let name: String
}

class NewWorkoutLogViewModel: ObservableObject {
    var workoutModeViewModel: WorkoutModeViewModel?
    @Published var workoutProgressLabel: String?
    @Published var maxInputs = [MaxInputViewModel?]()
    @Published var workouts: [Workout] = []
    @Published var oneRepMax = 100

    init() {
        let workoutPlanItem1 = WorkoutPlanItem(type: .pyramid, workouts: [
            Workout(name: "Barbell deadlift", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .exact(8), targetWeight: .exact(60)),
                WorkoutSet(targetVolume: .exact(6), targetWeight: .exact(60)),
                WorkoutSet(targetVolume: .exact(4), targetWeight: .exact(60)),
                WorkoutSet(targetVolume: .exact(2), targetWeight: .exact(60)),
                WorkoutSet(targetVolume: .exact(2), targetWeight: .exact(60)),
                WorkoutSet(targetVolume: .exact(10), targetWeight: .exact(60))
            ])
        ])

        let workoutPlanItem2 = WorkoutPlanItem(type: .emom, workouts: [
            Workout(name: "Pull ups", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .exact(12), targetWeight: nil),
                WorkoutSet(targetVolume: .exact(12), targetWeight: nil),
                WorkoutSet(targetVolume: .exact(12), targetWeight: nil),
            ]),
            Workout(name: "Assault bike", volumeUnit: .calorie, sets: [
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
            ]),
            Workout(name: "Run", volumeUnit: .distance, sets: [
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
                WorkoutSet(targetVolume: .maximum, targetWeight: nil),
            ]),
        ])

        let workoutPlanItem3 = WorkoutPlanItem(type: .superSet, workouts: [
            Workout(name: "A-Frame HSPU", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
            ]),
            Workout(name: "Single Arm Cable Row", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: nil),
            ])
        ])

        let workoutPlanItem4 = WorkoutPlanItem(type: .pyramid, workouts: [
            Workout(name: "Bench press", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
            ])
        ])

        maxInputs = workoutPlanItem1.workouts.map { workout in
            if workout.sets.contains(where: {
                if case .percentageOfMaximum = $0.targetWeight {
                    return true
                } else {
                    return false
                }
            }) {
                return MaxInputViewModel(title: workout.name)
            } else {
                return nil
            }
        }

        displayPyramidWorkout(workoutPlanItem: workoutPlanItem1)
//        displayEmomWorkout(workoutPlanItem: workoutPlanItem2)
//        displaySupersetWorkout(workoutPlanItem: workoutPlanItem3)
//        displayTestWorkout(workoutPlanItem: workoutPlanItem4)

        for workoutIndex in workouts.indices {
            workouts[workoutIndex].oneRepMax = maxInputs[safe: workoutIndex]??.value
        }
    }

    func displayPyramidWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workoutModeViewModel = WorkoutModeFormatter.formatPyramidWorkoutMode(workout: workout)
        workouts = [workout]
    }

    func displayEmomWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatEmomWorkoutMode(workouts: workoutPlanItem.workouts)
        workouts = workoutPlanItem.workouts
        workoutProgressLabel = "M"
    }

    func displaySupersetWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatSupersetWorkoutMode(workouts: workoutPlanItem.workouts)
        workouts = workoutPlanItem.workouts
        workoutProgressLabel = "A"
    }

    func displayTestWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workouts = [workout]
        workoutModeViewModel = WorkoutModeFormatter.formatTestWorkoutMode(workout: workout)
    }

    func saveTapped() {
        workouts.forEach { workout in
            workout.sets.forEach { workoutSet in
                print(workoutSet.volume)
            }
        }
    }
}
