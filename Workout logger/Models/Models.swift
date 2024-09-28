//
//  Models.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import Foundation

enum WorkoutTarget {
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
}

struct WorkoutPlanItem {
    let type: WorkoutType
    let workouts: [Workout]
}

struct Workout {
    let name: String
    let sets: [WorkoutSet]
}

struct WorkoutSet {
    let volumeUnit: VolumeUnit
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
}

struct WorkoutLog {
    let name: String
    var setLogs: [WorkoutSetLog]
}

struct WorkoutSetLog: Identifiable {
    let id = UUID().uuidString
    let volumeUnit: VolumeUnit
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
    var volume: Int?
    var weight: Int?

    enum CodingKeys: String, CodingKey {
        case volumeUnit
        case targetVolume
        case targetWeight
    }
}
