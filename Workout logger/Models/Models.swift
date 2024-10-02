//
//  Models.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import Foundation

enum WorkoutTarget: Hashable {
    case maximum
    case percentageOfMaximum(Int)
    case exact(Int)
    case interval(Int, Int)
}

struct WorkoutPlanItem: Codable, Hashable {
    let id: Int
    let type: WorkoutType
    let logDate: Date?
    var workouts: [Workout]

    init(id: Int, type: WorkoutType, logDate: Date? = nil, workouts: [Workout]) {
        self.id = id
        self.type = type
        self.logDate = logDate
        self.workouts = workouts
    }
}

enum WorkoutType: String, Codable, Hashable {
    case pyramid
    case emom
    case superset
    case test
}

enum VolumeUnit: String, Codable, Hashable {
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

struct Workout: Codable, Hashable {
    let id: Int
    let name: String
    let volumeUnit: VolumeUnit
    var oneRepMax: Int?
    var sets: [WorkoutSet]

    init(id: Int, name: String, volumeUnit: VolumeUnit, oneRepMax: Int? = nil, sets: [WorkoutSet]) {
        self.id = id
        self.name = name
        self.volumeUnit = volumeUnit
        self.oneRepMax = oneRepMax
        self.sets = sets
    }
}

struct WorkoutSet: Identifiable, Codable, Hashable {
    let id: Int
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
    var volume: Int?
    var weight: Int?

    init(id: Int, targetVolume: WorkoutTarget, targetWeight: WorkoutTarget?, volume: Int? = nil, weight: Int? = nil) {
        self.id = id
        self.targetVolume = targetVolume
        self.targetWeight = targetWeight
        self.volume = volume
        self.weight = weight
    }

    enum CodingKeys: String, CodingKey {
        case id
        case targetVolume
        case targetWeight
        case volume
        case weight
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode (Int.self, forKey: .id)
        volume = try values.decodeIfPresent(Int.self, forKey: .volume)
        weight = try values.decodeIfPresent(Int.self, forKey: .weight)

        let apiTargetVolume = try values.decode(ApiWorkoutTarget.self, forKey: .targetVolume)
        let apiTargetWeight = try values.decode(ApiWorkoutTarget?.self, forKey: .targetWeight)

        targetVolume = apiTargetVolume.asWorkoutTarget
        targetWeight = apiTargetWeight?.asWorkoutTarget
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container (keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(volume, forKey: .volume)
        try container.encode(weight, forKey: .weight)

        let apiTargetVolume = ApiWorkoutTarget(from: targetVolume)
        let apiTargetWeight = ApiWorkoutTarget(from: targetWeight)

        try container.encode(apiTargetVolume, forKey: .targetVolume)
        try container.encode(apiTargetWeight, forKey: .targetWeight)
    }
}

private struct ApiWorkoutTarget: Codable {
    let type: String
    let value: Int?
    let start: Int?
    let end: Int?

    init(type: String, value: Int? = nil, start: Int? = nil, end: Int? = nil) {
        self.type = type
        self.value = value
        self.start = start
        self.end = end
    }

    init?(from workoutTarget: WorkoutTarget?) {
        switch workoutTarget {
        case .maximum:
            self.init(type: "maximum", value: nil, start: nil, end: nil)
        case .percentageOfMaximum(let percentage):
            self.init(type: "percentageOfMaximum", value: percentage, start: nil, end: nil)
        case .exact(let exactValue):
            self.init(type: "exact", value: exactValue, start: nil, end: nil)
        case .interval(let startValue, let endValue):
            self.init(type: "interval", value: nil, start: startValue, end: endValue)
        case .none:
            return nil
        }
    }

    var asWorkoutTarget: WorkoutTarget {
        switch type {
        case "percentageOfMaximum":
            if let value {
                return .percentageOfMaximum(value)
            }
            fallthrough
        case "exact":
            if let value {
                return .exact(value)
            }
            fallthrough
        case "interval":
            if let start, let end {
                return .interval(start, end)
            }
            fallthrough
        default:
            return .maximum
        }
    }
}

// MARK: - Extensions

extension WorkoutTarget {
    func targetAchieved(value: Int, oneRepMax: Int?) -> Bool {
        switch self {
        case .maximum:
            return true
        case .percentageOfMaximum(let percentage):
            return Double(value) >= (Double(percentage) / 100.0) * Double(oneRepMax ?? 0)
        case .exact(let exactTarget):
            return value >= exactTarget
        case .interval(let minTarget, let maxTarget):
            return value >= minTarget && value <= maxTarget
        }
    }

    func textFieldPlaceholder(oneRepMax: Int?) -> String {
        switch self {
        case .maximum:
            return "Max"
        case .percentageOfMaximum(let percentage):
            return String(format: "%.0f", (Double(percentage) / 100.0) * Double(oneRepMax ?? 0))
        case .exact(let exactValue):
            return String(exactValue)
        case .interval(let minTarget, _):
            return String(minTarget)
        }
    }
}

extension Workout {
    func bestSetIndex() -> Int? {
        var bestSetIndex: Int? = nil
        var highestScore: Int = 0

        for (index, set) in sets.enumerated() {
            let volumeAchieved = set.volume != nil && set.targetVolume.targetAchieved(value: set.volume!, oneRepMax: oneRepMax)
            var currentScore: Int? = 0

            if volumeAchieved {
                if set.targetWeight == nil {
                    currentScore = set.volume
                } else {
                    currentScore = set.weight
                }
            }

            if currentScore ?? 0 > highestScore {
                highestScore = currentScore ?? 0
                bestSetIndex = index
            }
        }

        return bestSetIndex
    }
}
