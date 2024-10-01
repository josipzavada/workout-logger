//
//  WorkoutLogViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

class WorkoutLogViewModel {
    var workoutModeViewModel: WorkoutModeViewModel?
    var workoutProgressLabel: String?
    var maxViews = [WorkoutMaxViewModel?]()
    var workouts: [Workout] = []

    init(workoutPlanItem: WorkoutPlanItem) {

        maxViews = workoutPlanItem.workouts.map { workout in
            if workout.sets.contains(where: {
                if case .percentageOfMaximum = $0.targetWeight {
                    return true
                } else {
                    return false
                }
            }),
               let maxValue = workout.oneRepMax
            {
                return WorkoutMaxViewModel(title: workout.name, maxValue: maxValue)
            } else {
                return nil
            }
        }

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

//        let workoutPlanItem1 = WorkoutPlanItem(id: 1, type: .pyramid, workouts: [
//            Workout(name: "Barbell deadlift", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .exact(8), targetWeight: .exact(60), volume: 8, weight: 70),
//                WorkoutSet(id: 2, targetVolume: .exact(6), targetWeight: .exact(60), volume: 6, weight: 50),
//                WorkoutSet(id: 3, targetVolume: .exact(4), targetWeight: .exact(60), volume: 3, weight: 70),
//                WorkoutSet(id: 4, targetVolume: .exact(2), targetWeight: .exact(60), volume: 2, weight: 70),
//                WorkoutSet(id: 5, targetVolume: .exact(2), targetWeight: .exact(60), volume: 2, weight: 70),
//                WorkoutSet(id: 6, targetVolume: .exact(10), targetWeight: .exact(60), volume: 8, weight: 50)
//            ])
//        ])
//
//        let workoutPlanItem2 = WorkoutPlanItem(id: 2, type: .emom, workouts: [
//            Workout(name: "Pull ups", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .exact(12), targetWeight: nil, volume: 12),
//                WorkoutSet(id: 2, targetVolume: .exact(12), targetWeight: nil, volume: 11),
//                WorkoutSet(id: 3, targetVolume: .exact(12), targetWeight: nil, volume: 13),
//            ]),
//            Workout(name: "Assault bike", volumeUnit: .calorie, sets: [
//                WorkoutSet(id: 1, targetVolume: .maximum, targetWeight: nil, volume: 8),
//                WorkoutSet(id: 2, targetVolume: .maximum, targetWeight: nil, volume: 8),
//                WorkoutSet(id: 3, targetVolume: .maximum, targetWeight: nil, volume: 8),
//            ]),
//            Workout(name: "Run", volumeUnit: .distance, sets: [
//                WorkoutSet(id: 4, targetVolume: .maximum, targetWeight: nil, volume: 30),
//                WorkoutSet(id: 5, targetVolume: .maximum, targetWeight: nil, volume: 25),
//                WorkoutSet(id: 6, targetVolume: .maximum, targetWeight: nil, volume: 20),
//            ]),
//        ])
//
//        let workoutPlanItem3 = WorkoutPlanItem(id: 3, type: .superset, workouts: [
//            Workout(name: "A-Frame HSPU", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .interval(8, 12), targetWeight: nil, volume: 9),
//                WorkoutSet(id: 2, targetVolume: .interval(8, 12), targetWeight: nil, volume: 7),
//                WorkoutSet(id: 3, targetVolume: .interval(8, 12), targetWeight: nil, volume: 12),
//            ]),
//            Workout(name: "Single Arm Cable Row", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 4, targetVolume: .interval(8, 12), targetWeight: .exact(100), volume: 12),
//                WorkoutSet(id: 5, targetVolume: .interval(8, 12), targetWeight: .exact(100), volume: 11),
//                WorkoutSet(id: 6, targetVolume: .interval(8, 12), targetWeight: .exact(100), volume: 7),
//            ])
//        ])
//
//        let workoutPlanItem4 = WorkoutPlanItem(id: 4, type: .pyramid, workouts: [
//            Workout(name: "Bench press", volumeUnit: .reps, oneRepMax: 100, sets: [
//                WorkoutSet(id: 1, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60), volume: 5, weight: 70),
//                WorkoutSet(id: 2, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60), volume: 4, weight: 50),
//                WorkoutSet(id: 3, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60), volume: 5, weight: 50),
//            ])
//        ])
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
}
