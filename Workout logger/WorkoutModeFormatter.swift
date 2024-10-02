//
//  WorkoutModeFormatter.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

enum WorkoutModeFormatter {
    static func formatPyramidWorkoutMode(workout: Workout) -> WorkoutModeViewModel {
        let setTargetsString = formatPyramidTarget(workout: workout)
        let title = "\(Constants.WorkoutMode.pyramid): \(workout.name)"

        let workoutPreviews = WorkoutPreviewViewModel(target: nil, name: workout.name)
        return WorkoutModeViewModel(title: title, target: setTargetsString, workoutPreviews: [workoutPreviews])
    }

    static func formatEmomWorkoutMode(workouts: [Workout]) -> WorkoutModeViewModel {
        let numberOfRoundsString = formatEmomTarget(workouts: workouts)
        let workoutPreviews = workouts.map { workout in
            let targetValue = workout.sets.first?.targetVolume
            let targetWeight = workout.sets.first?.targetWeight
            let targetValueUnit = workout.volumeUnit

            let areAllValueTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetVolume == targetValue }
            let areAllWeightTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetWeight == targetValue }

            var workoutValueAndWeight = ""
            if areAllValueTargetsEqual {
                switch targetValue {
                case .maximum:
                    workoutValueAndWeight += "\(Constants.WorkoutMode.max) \(targetValueUnit.name)"
                case .percentageOfMaximum(let percentage):
                    workoutValueAndWeight += "\(percentage)% \(Constants.WorkoutLog.oneRepMaxSuffix)"
                case .exact(let exactTarget):
                    workoutValueAndWeight += "\(exactTarget) \(targetValueUnit.name)"
                case .interval(let minTarget, let maxTarget):
                    workoutValueAndWeight += "\(minTarget)-\(maxTarget) \(targetValueUnit.name)"
                case .none:
                    break
                }
            }

            if areAllWeightTargetsEqual {
                workoutValueAndWeight += " "
                switch targetWeight {
                case .maximum:
                    workoutValueAndWeight += "\(Constants.WorkoutMode.max) \(Constants.WorkoutLog.kg)"
                case .exact(let exactTarget):
                    workoutValueAndWeight += "\(exactTarget) \(Constants.WorkoutLog.kg)"
                case .interval(let minTarget, let maxTarget):
                    workoutValueAndWeight += "\(minTarget)-\(maxTarget) \(Constants.WorkoutLog.kg)"
                case .percentageOfMaximum, .none:
                    break
                }
            }

            return WorkoutPreviewViewModel(target: workoutValueAndWeight, name: workout.name)
        }
        return WorkoutModeViewModel(title: Constants.WorkoutMode.emom, target: numberOfRoundsString, workoutPreviews: workoutPreviews)
    }

    static func formatSupersetWorkoutMode(workouts: [Workout]) -> WorkoutModeViewModel {
        let target = formatSupersetTarget(workouts: workouts)
        let workoutPreviews = workouts.map { WorkoutPreviewViewModel(target: nil, name: $0.name) }
        return WorkoutModeViewModel(title: Constants.WorkoutMode.supersets, target: target, workoutPreviews: workoutPreviews)
    }

    static func formatTestWorkoutMode(workout: Workout) -> WorkoutModeViewModel {
        let workoutValueAndWeight = formatTestTarget(workout: workout)
        let title = "\(workout.name) \(Constants.WorkoutMode.test)"
        let workoutPreviews = WorkoutPreviewViewModel(target: nil, name: workout.name)
        return WorkoutModeViewModel(title: title, target: workoutValueAndWeight, workoutPreviews: [workoutPreviews])
    }

    static func formatPyramidTarget(workout: Workout) -> String {
        let setTargets = workout.sets.compactMap({ workoutSet in
            switch workoutSet.targetVolume {
            case .exact(let value):
                return String(value)
            default:
                return nil
            }
        })

        return setTargets.joined(separator: " - ")
    }

    static func formatEmomTarget(workouts: [Workout]) -> String {
        let numberOfRounds = workouts.reduce(0) { $0 + $1.sets.count }
        return "\(numberOfRounds) \(Constants.WorkoutMode.rounds)"
    }

    static func formatSupersetTarget(workouts: [Workout]) -> String {
        let workoutsSetsCount = workouts.map { $0.sets.count }
        let areAllSetsEqual = workoutsSetsCount.allSatisfy { $0 == workoutsSetsCount.first }

        var description = areAllSetsEqual ? "\(workoutsSetsCount.first ?? 0) x " : ""

        let firstWorkout = workouts.first
        let targetValue = firstWorkout?.sets.first?.targetVolume
        let targetWeight = firstWorkout?.sets.first?.targetWeight
        let targetValueUnit = firstWorkout?.volumeUnit

        let areAllValueTargetsEqual = workouts.allSatisfy { $0.sets.allSatisfy { $0.targetVolume == targetValue } }
        let areAllWeightTargetsEqual = workouts.allSatisfy { $0.sets.allSatisfy { $0.targetWeight == targetWeight } }

        if areAllValueTargetsEqual {
            description += formatTargetValue(targetValue, unit: targetValueUnit?.name ?? "")
        }
        if areAllWeightTargetsEqual {
            description += " " + formatTargetWeight(targetWeight)
        }

        return description.trimmingCharacters(in: .whitespaces)
    }

    static func formatTestTarget(workout: Workout) -> String {
        let targetValue = workout.sets.first?.targetVolume
        let targetWeight = workout.sets.first?.targetWeight
        let targetValueUnit = workout.volumeUnit

        let areAllValueTargetsEqual = workout.sets.allSatisfy { $0.targetVolume == targetValue }
        let areAllWeightTargetsEqual = workout.sets.allSatisfy { $0.targetWeight == targetWeight }

        var description = "\(workout.sets.count) x "
        if areAllValueTargetsEqual {
            description += formatTargetValue(targetValue, unit: targetValueUnit.name)
        }
        if areAllWeightTargetsEqual {
            description += (description.hasSuffix("x ") ? "" : " @ ") + formatTargetWeight(targetWeight)
        }

        return description.trimmingCharacters(in: .whitespaces)
    }

    static func formatTargetValue(_ targetValue: WorkoutTarget?, unit: String) -> String {
        switch targetValue {
        case .maximum:
            return "\(Constants.WorkoutMode.max) \(unit)"
        case .percentageOfMaximum(let percentage):
            return "\(percentage)% \(Constants.WorkoutLog.oneRepMaxSuffix)"
        case .exact(let exactTarget):
            return "\(exactTarget) \(unit)"
        case .interval(let minTarget, let maxTarget):
            return "\(minTarget)-\(maxTarget) \(unit)"
        case .none:
            return ""
        }
    }

    static func formatTargetWeight(_ targetWeight: WorkoutTarget?) -> String {
        switch targetWeight {
        case .maximum:
            return "\(Constants.WorkoutMode.max) \(Constants.WorkoutLog.kg)"
        case .exact(let exactTarget):
            return "\(exactTarget) \(Constants.WorkoutLog.kg)"
        case .interval(let minTarget, let maxTarget):
            return "\(minTarget)-\(maxTarget) \(Constants.WorkoutLog.kg)"
        case .percentageOfMaximum(let percentage):
            return "\(percentage)% \(Constants.WorkoutLog.oneRepMaxSuffix)"
        case .none:
            return ""
        }
    }

    static func workoutPathOrder(index: Int, numberOfWorkouts: Int) -> WorkoutPathOrder {
        if index == 0 {
            return WorkoutPathOrder.first
        } else if index == numberOfWorkouts - 1 {
            return WorkoutPathOrder.last
        } else {
            return WorkoutPathOrder.middle
        }
    }
}
