//
//  WorkoutLogViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import SwiftUI

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
    var workoutPreviewViewModel: WorkoutModeViewModel?
    @Published var workouts: [Workout] = []

    init() {
        let workoutPlanItem1 = WorkoutPlanItem(type: .pyramid, workouts: [
            Workout(name: "Barbell deadlift", sets: [
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(8), targetWeight: nil),
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(6), targetWeight: nil),
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(4), targetWeight: nil),
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(2), targetWeight: nil),
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(2), targetWeight: nil),
                WorkoutSet(volumeUnit: .rep, targetVolume: .exact(10), targetWeight: nil)
            ])
        ])
        displayPyramidWorkout(workoutPlanItem: workoutPlanItem1)
    }

    func displayPyramidWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        let setTargets = workout.sets.compactMap({ workoutSet in
            switch workoutSet.targetVolume {
            case .exact(let value):
                return String(value)
            default:
                return nil
            }
        })

        let setTargetsString = setTargets.joined(separator: " - ")
        let title = "Pyramid: \(workout.name)"

        workouts = [workout]
        let workoutPreviews = workouts.map({ workout in
            return WorkoutPreviewViewModel(target: nil, name: workout.name)
        })

        workoutPreviewViewModel = WorkoutModeViewModel(title: title, target: setTargetsString, workoutPreviews: workoutPreviews)
    }
}
