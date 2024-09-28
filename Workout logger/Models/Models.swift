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
    case rep
    case calorie
    case distance

    var name: String {
        switch self {
        case .rep:
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
    let sets: [WorkoutSet]
}

struct WorkoutSet {
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
}

struct WorkoutLog {
    let name: String
    let volumeUnit: VolumeUnit
    var setLogs: [WorkoutSetLog]
}

struct WorkoutSetLog: Identifiable {
    let id = UUID().uuidString
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
    let oneRepMax: Int?
    var volume: Int?
    var weight: Int?

    enum CodingKeys: String, CodingKey {
        case volumeUnit
        case targetVolume
        case targetWeight
    }
}
