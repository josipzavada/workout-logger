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
            let targetVolume = workout.sets.first?.targetVolume
            let targetWeight = workout.sets.first?.targetWeight
            let targetVolumeUnit = workout.volumeUnit

            let areAllVolumeTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetVolume == targetVolume }
            let areAllWeightTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetWeight == targetVolume }

            var workoutVolumeAndWeight = ""
            if areAllVolumeTargetsEqual {
                switch targetVolume {
                case .maximum:
                    workoutVolumeAndWeight += "\(Constants.WorkoutMode.max) \(targetVolumeUnit.name)"
                case .percentageOfMaximum(let percentage):
                    workoutVolumeAndWeight += "\(percentage)% \(Constants.WorkoutLog.oneRepMaxSuffix)"
                case .exact(let exactTarget):
                    workoutVolumeAndWeight += "\(exactTarget) \(targetVolumeUnit.name)"
                case .interval(let minTarget, let maxTarget):
                    workoutVolumeAndWeight += "\(minTarget)-\(maxTarget) \(targetVolumeUnit.name)"
                case .none:
                    break
                }
            }

            if areAllWeightTargetsEqual {
                workoutVolumeAndWeight += " "
                switch targetWeight {
                case .maximum:
                    workoutVolumeAndWeight += "\(Constants.WorkoutMode.max) \(Constants.WorkoutLog.kg)"
                case .exact(let exactTarget):
                    workoutVolumeAndWeight += "\(exactTarget) \(Constants.WorkoutLog.kg)"
                case .interval(let minTarget, let maxTarget):
                    workoutVolumeAndWeight += "\(minTarget)-\(maxTarget) \(Constants.WorkoutLog.kg)"
                case .percentageOfMaximum, .none:
                    break
                }
            }

            return WorkoutPreviewViewModel(target: workoutVolumeAndWeight, name: workout.name)
        }
        return WorkoutModeViewModel(title: Constants.WorkoutMode.emom, target: numberOfRoundsString, workoutPreviews: workoutPreviews)
    }

    static func formatSupersetWorkoutMode(workouts: [Workout]) -> WorkoutModeViewModel {
        let target = formatSupersetTarget(workouts: workouts)
        let workoutPreviews = workouts.map { WorkoutPreviewViewModel(target: nil, name: $0.name) }
        return WorkoutModeViewModel(title: Constants.WorkoutMode.supersets, target: target, workoutPreviews: workoutPreviews)
    }

    static func formatTestWorkoutMode(workout: Workout) -> WorkoutModeViewModel {
        let workoutVolumeAndWeight = formatTestTarget(workout: workout)
        let title = "\(workout.name) \(Constants.WorkoutMode.test)"
        let workoutPreviews = WorkoutPreviewViewModel(target: nil, name: workout.name)
        return WorkoutModeViewModel(title: title, target: workoutVolumeAndWeight, workoutPreviews: [workoutPreviews])
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
        let targetVolume = firstWorkout?.sets.first?.targetVolume
        let targetWeight = firstWorkout?.sets.first?.targetWeight
        let targetVolumeUnit = firstWorkout?.volumeUnit

        let areAllVolumeTargetsEqual = workouts.allSatisfy { $0.sets.allSatisfy { $0.targetVolume == targetVolume } }
        let areAllWeightTargetsEqual = workouts.allSatisfy { $0.sets.allSatisfy { $0.targetWeight == targetWeight } }

        if areAllVolumeTargetsEqual {
            description += formatTargetVolume(targetVolume, unit: targetVolumeUnit?.name ?? "")
        }
        if areAllWeightTargetsEqual {
            description += " " + formatTargetWeight(targetWeight)
        }

        return description.trimmingCharacters(in: .whitespaces)
    }

    static func formatTestTarget(workout: Workout) -> String {
        let targetVolume = workout.sets.first?.targetVolume
        let targetWeight = workout.sets.first?.targetWeight
        let targetVolumeUnit = workout.volumeUnit

        let areAllVolumeTargetsEqual = workout.sets.allSatisfy { $0.targetVolume == targetVolume }
        let areAllWeightTargetsEqual = workout.sets.allSatisfy { $0.targetWeight == targetWeight }

        var description = "\(workout.sets.count) x "
        if areAllVolumeTargetsEqual {
            description += formatTargetVolume(targetVolume, unit: targetVolumeUnit.name)
        }
        if areAllWeightTargetsEqual {
            description += (description.hasSuffix("x ") ? "" : " @ ") + formatTargetWeight(targetWeight)
        }

        return description.trimmingCharacters(in: .whitespaces)
    }

    static func formatTargetVolume(_ targetVolume: WorkoutTarget?, unit: String) -> String {
        switch targetVolume {
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

    static func isLastInWorkoutPath(index: Int, numberOfWorkouts: Int) -> Bool {
        return index == (numberOfWorkouts - 1) || numberOfWorkouts <= 1
    }
}
