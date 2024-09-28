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
    @Published var workouts: [WorkoutLog] = []
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
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
            ]),
            Workout(name: "Single Arm Cable Row", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
                WorkoutSet(targetVolume: .interval(8, 12), targetWeight: .exact(100)),
            ])
        ])

        let workoutPlanItem4 = WorkoutPlanItem(type: .pyramid, workouts: [
            Workout(name: "Bench press", volumeUnit: .rep, sets: [
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
                WorkoutSet(targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
            ])
        ])

//        displayPyramidWorkout(workoutPlanItem: workoutPlanItem1)
//        displayEpomWorkout(workoutPlanItem: workoutPlanItem2)
//        displaySupersetWorkout(workoutPlanItem: workoutPlanItem3)
        displayTestWorkout(workoutPlanItem: workoutPlanItem4)
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

        let setLogs = workout.sets.map {
            WorkoutSetLog(targetVolume: $0.targetVolume, targetWeight: $0.targetWeight, oneRepMax: oneRepMax, volume: nil, weight: nil)
        }
        let workoutLog = WorkoutLog(name: workout.name, volumeUnit: workout.volumeUnit, setLogs: setLogs)
        workouts = [workoutLog]
        let workoutPreviews = workouts.map({ workout in
            return WorkoutPreviewViewModel(target: nil, name: workout.name)
        })

        workoutPreviewViewModel = WorkoutModeViewModel(title: title, target: setTargetsString, workoutPreviews: workoutPreviews)
    }

    func displayEpomWorkout(workoutPlanItem: WorkoutPlanItem) {
        let numberOfRounds = workoutPlanItem.workouts.map { $0.sets.count }.reduce(0, +)
        let workoutPreviews = workoutPlanItem.workouts.map { workout in
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
        workoutPreviewViewModel = WorkoutModeViewModel(title: "EPOM", target: "\(numberOfRounds) rounds", workoutPreviews: workoutPreviews)
        workouts = workoutPlanItem.workouts.map { workout in
            let setLogs = workout.sets.map { workoutSet in
                WorkoutSetLog(targetVolume: workoutSet.targetVolume, targetWeight: workoutSet.targetWeight, oneRepMax: oneRepMax, volume: nil, weight: nil)
            }
            return WorkoutLog(name: workout.name, volumeUnit: workout.volumeUnit, setLogs: setLogs)
        }
    }

    func displaySupersetWorkout(workoutPlanItem: WorkoutPlanItem) {
        let workoutsSetsCount = workoutPlanItem.workouts.map { $0.sets.count }
        let areAllSetsEqual = workoutsSetsCount.allSatisfy { $0 == workoutsSetsCount.first }

        let targetValue = workoutPlanItem.workouts.first?.sets.first?.targetVolume
        let targetWeight = workoutPlanItem.workouts.first?.sets.first?.targetWeight
        let targetValueUnit = workoutPlanItem.workouts.first?.volumeUnit

        let areAllValueTargetsEqual = workoutPlanItem.workouts.allSatisfy { workout in
            return workout.sets.allSatisfy { workoutSet in workoutSet.targetVolume == targetValue }
        }

        let areAllWeightTargetsEqual = workoutPlanItem.workouts.allSatisfy { workout in
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

        let workoutPreviews = workoutPlanItem.workouts.map { WorkoutPreviewViewModel(target: nil, name: $0.name) }
        workoutPreviewViewModel = WorkoutModeViewModel(title: "Supersets", target: valueAndWeightDescription, workoutPreviews: workoutPreviews)
        workouts = workoutPlanItem.workouts.map { workout in
            let setLogs = workout.sets.map { workoutSet in
                WorkoutSetLog(targetVolume: workoutSet.targetVolume, targetWeight: workoutSet.targetWeight, oneRepMax: oneRepMax, volume: nil, weight: nil)
            }
            return WorkoutLog(name: workout.name, volumeUnit: workout.volumeUnit, setLogs: setLogs)
        }
    }

    func displayTestWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }

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

        let title = "\(workout.name) Test"

        let setLogs = workout.sets.map {
            WorkoutSetLog(targetVolume: $0.targetVolume, targetWeight: $0.targetWeight, oneRepMax: oneRepMax, volume: nil, weight: nil)
        }
        let workoutLog = WorkoutLog(name: workout.name, volumeUnit: workout.volumeUnit, setLogs: setLogs)
        workouts = [workoutLog]
        let workoutPreviews = workouts.map({ workout in
            return WorkoutPreviewViewModel(target: nil, name: workout.name)
        })

        workoutPreviewViewModel = WorkoutModeViewModel(title: title, target: workoutValueAndWeight, workoutPreviews: workoutPreviews)
    }

    func saveTapped() {
        workouts.forEach { workout in
            workout.setLogs.forEach { workoutSet in
                print(workoutSet.volume)
            }
        }
    }
}
