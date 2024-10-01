//
//  WorkoutModeFormatter.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

enum WorkoutModeFormatter {
    static func formatPyramidWorkoutMode(workout: Workout) -> WorkoutModeViewModel {
        let setTargetsString = formatPyramidTarget(workout: workout)
        let title = "Pyramid: \(workout.name)"

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
                    workoutValueAndWeight += "Max \(targetValueUnit.name)"
                case .percentageOfMaximum(let percentage):
                    workoutValueAndWeight += "\(percentage)% 1RM"
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
                    workoutValueAndWeight += "Max kg"
                case .exact(let exactTarget):
                    workoutValueAndWeight += "\(exactTarget) kg"
                case .interval(let minTarget, let maxTarget):
                    workoutValueAndWeight += "\(minTarget)-\(maxTarget) kg"
                case .percentageOfMaximum, .none:
                    break
                }
            }

            return WorkoutPreviewViewModel(target: workoutValueAndWeight, name: workout.name)
        }
        return WorkoutModeViewModel(title: "EMOM", target: numberOfRoundsString, workoutPreviews: workoutPreviews)
    }

    static func formatSupersetWorkoutMode(workouts: [Workout]) -> WorkoutModeViewModel {
        let target = formatSupersetTarget(workouts: workouts)
        let workoutPreviews = workouts.map { WorkoutPreviewViewModel(target: nil, name: $0.name) }
        return WorkoutModeViewModel(title: "Supersets", target: target, workoutPreviews: workoutPreviews)
    }

    static func formatTestWorkoutMode(workout: Workout) -> WorkoutModeViewModel {
        let workoutValueAndWeight = formatTestTarget(workout: workout)
        let title = "\(workout.name) Test"
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
        let numberOfRounds = workouts.map { $0.sets.count }.reduce(0, +)
        return "\(numberOfRounds) rounds"
    }

    static func formatSupersetTarget(workouts: [Workout]) -> String {
        let workoutsSetsCount = workouts.map { $0.sets.count }
        let areAllSetsEqual = workoutsSetsCount.allSatisfy { $0 == workoutsSetsCount.first }

        let targetValue = workouts.first?.sets.first?.targetVolume
        let targetWeight = workouts.first?.sets.first?.targetWeight
        let targetValueUnit = workouts.first?.volumeUnit

        let areAllValueTargetsEqual = workouts.allSatisfy { workout in
            return workout.sets.allSatisfy { workoutSet in workoutSet.targetVolume == targetValue }
        }

        let areAllWeightTargetsEqual = workouts.allSatisfy { workout in
            return workout.sets.allSatisfy { workoutSet in workoutSet.targetWeight == targetValue }
        }

        var valueAndWeightDescription = ""

        if areAllSetsEqual, let fistSetCount =  workoutsSetsCount.first {
            valueAndWeightDescription += "\(fistSetCount) x"
        }

        if areAllValueTargetsEqual {
            valueAndWeightDescription += " "
            switch targetValue {
            case .maximum:
                valueAndWeightDescription += "Max \(targetValueUnit?.name ?? "")"
            case .percentageOfMaximum(let percentage):
                valueAndWeightDescription += "\(percentage)% 1RM"
            case .exact(let exactTarget):
                valueAndWeightDescription += "\(exactTarget) \(targetValueUnit?.name ?? "")"
            case .interval(let minTarget, let maxTarget):
                valueAndWeightDescription += "\(minTarget)-\(maxTarget) \(targetValueUnit?.name ?? "")"
            case .none:
                break
            }
        }

        if areAllWeightTargetsEqual {
            valueAndWeightDescription += " "
            switch targetWeight {
            case .maximum:
                valueAndWeightDescription += "Max kg"
            case .exact(let exactTarget):
                valueAndWeightDescription += "\(exactTarget) kg"
            case .interval(let minTarget, let maxTarget):
                valueAndWeightDescription += "\(minTarget)-\(maxTarget) kg"
            case .percentageOfMaximum, .none:
                break
            }
        }
        return valueAndWeightDescription
    }

    static func formatTestTarget(workout: Workout) -> String {
        let targetValue = workout.sets.first?.targetVolume
        let targetWeight = workout.sets.first?.targetWeight
        let targetValueUnit = workout.volumeUnit

        let areAllValueTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetVolume == targetValue }
        let areAllWeightTargetsEqual = workout.sets.allSatisfy { workoutSet in workoutSet.targetWeight == targetWeight }

        var workoutValueAndWeight = ""
        if areAllValueTargetsEqual {
            switch targetValue {
            case .maximum:
                workoutValueAndWeight += "Max \(targetValueUnit.name)"
            case .percentageOfMaximum(let percentage):
                workoutValueAndWeight += "\(percentage)% 1RM"
            case .exact(let exactTarget):
                workoutValueAndWeight += "\(exactTarget) \(targetValueUnit.name)"
            case .interval(let minTarget, let maxTarget):
                workoutValueAndWeight += "\(minTarget)-\(maxTarget) \(targetValueUnit.name)"
            case .none:
                break
            }
        }

        if areAllWeightTargetsEqual {
            if workoutValueAndWeight != "" {
                workoutValueAndWeight += " @ "
            }
            switch targetWeight {
            case .maximum:
                workoutValueAndWeight += "Max kg"
            case .exact(let exactTarget):
                workoutValueAndWeight += "\(exactTarget) kg"
            case .interval(let minTarget, let maxTarget):
                workoutValueAndWeight += "\(minTarget)-\(maxTarget) kg"
            case .percentageOfMaximum(let percentage):
                workoutValueAndWeight += "\(percentage) % 1RM"
            case .none:
                break
            }
        }

        workoutValueAndWeight = "\(workout.sets.count) x \(workoutValueAndWeight)"
        return workoutValueAndWeight
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
