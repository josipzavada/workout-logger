//
//  Models.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import Foundation

enum WorkoutTarget: Equatable {
    case maximum
    case percentageOfMaximum(Int)
    case exact(Int)
    case interval(Int, Int)
}

enum WorkoutType {
    case pyramid
    case emom
    case superSet
    case test
}

enum VolumeUnit {
    case reps
    case calorie
    case distance

    var name: String {
        switch self {
        case .reps:
            return "reps"
        case .calorie:
            return "calories"
        case .distance:
            return "m"
        }
    }
}

struct WorkoutPlanItem {
    let type: WorkoutType
    let workouts: [Workout]
}

struct Workout {
    let name: String
    let volumeUnit: VolumeUnit
    var oneRepMax: Int?
    var sets: [WorkoutSet]
}

struct WorkoutSet: Identifiable {
    let id: Int
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
    var volume: Int?
    var weight: Int?
}
