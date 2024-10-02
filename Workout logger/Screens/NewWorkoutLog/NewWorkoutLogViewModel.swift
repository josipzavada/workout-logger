//
//  WorkoutLogViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 28.09.2024..
//

import SwiftUI

struct MaxInputViewModel {
    let title: String
    var value: Int?
}

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

@MainActor
class NewWorkoutLogViewModel: ObservableObject {
    var workoutModeViewModel: WorkoutModeViewModel?
    @Published var workoutProgressLabel: String?
    @Published var workoutPlanItem: WorkoutPlanItem
    @Published var oneRepMax: Int?
    @Published var isLoading = false
    @Published var showError = false

    init(workoutPlanItem: WorkoutPlanItem) {
        self.workoutPlanItem = workoutPlanItem

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
//                WorkoutSet(id: 1, targetVolume: .exact(8), targetWeight: .exact(60)),
//                WorkoutSet(id: 2, targetVolume: .exact(6), targetWeight: .exact(60)),
//                WorkoutSet(id: 3, targetVolume: .exact(4), targetWeight: .exact(60)),
//                WorkoutSet(id: 4, targetVolume: .exact(2), targetWeight: .exact(60)),
//                WorkoutSet(id: 5, targetVolume: .exact(2), targetWeight: .exact(60)),
//                WorkoutSet(id: 6, targetVolume: .exact(10), targetWeight: .exact(60))
//            ])
//        ])
//
//        let workoutPlanItem2 = WorkoutPlanItem(id: 2, type: .emom, workouts: [
//            Workout(name: "Pull ups", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .exact(12), targetWeight: nil),
//                WorkoutSet(id: 2, targetVolume: .exact(12), targetWeight: nil),
//                WorkoutSet(id: 3, targetVolume: .exact(12), targetWeight: nil),
//            ]),
//            Workout(name: "Assault bike", volumeUnit: .calorie, sets: [
//                WorkoutSet(id: 1, targetVolume: .maximum, targetWeight: nil),
//                WorkoutSet(id: 2, targetVolume: .maximum, targetWeight: nil),
//                WorkoutSet(id: 3, targetVolume: .maximum, targetWeight: nil),
//            ]),
//            Workout(name: "Run", volumeUnit: .distance, sets: [
//                WorkoutSet(id: 1, targetVolume: .maximum, targetWeight: nil),
//                WorkoutSet(id: 2, targetVolume: .maximum, targetWeight: nil),
//                WorkoutSet(id: 3, targetVolume: .maximum, targetWeight: nil),
//            ]),
//        ])
//
//        let workoutPlanItem3 = WorkoutPlanItem(id: 3, type: .superset, workouts: [
//            Workout(name: "A-Frame HSPU", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .interval(8, 12), targetWeight: nil),
//                WorkoutSet(id: 2, targetVolume: .interval(8, 12), targetWeight: nil),
//                WorkoutSet(id: 3, targetVolume: .interval(8, 12), targetWeight: nil),
//            ]),
//            Workout(name: "Single Arm Cable Row", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .interval(8, 12), targetWeight: nil),
//                WorkoutSet(id: 2, targetVolume: .interval(8, 12), targetWeight: nil),
//                WorkoutSet(id: 3, targetVolume: .interval(8, 12), targetWeight: nil),
//            ])
//        ])
//
//        let workoutPlanItem4 = WorkoutPlanItem(id: 4, type: .pyramid, workouts: [
//            Workout(name: "Bench press", volumeUnit: .reps, sets: [
//                WorkoutSet(id: 1, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
//                WorkoutSet(id: 2, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
//                WorkoutSet(id: 3, targetVolume: .exact(5), targetWeight: .percentageOfMaximum(60)),
//            ])
//        ])
//
//        maxInputs = workoutPlanItem1.workouts.map { workout in
//            if workout.sets.contains(where: {
//                if case .percentageOfMaximum = $0.targetWeight {
//                    return true
//                } else {
//                    return false
//                }
//            }) {
//                return MaxInputViewModel(title: workout.name)
//            } else {
//                return nil
//            }
//        }
//
//        displayPyramidWorkout(workoutPlanItem: workoutPlanItem1)
//        displayEmomWorkout(workoutPlanItem: workoutPlanItem2)
//        displaySupersetWorkout(workoutPlanItem: workoutPlanItem3)
//        displayTestWorkout(workoutPlanItem: workoutPlanItem4)
    }

    func displayPyramidWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workoutModeViewModel = WorkoutModeFormatter.formatPyramidWorkoutMode(workout: workout)
    }

    func displayEmomWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatEmomWorkoutMode(workouts: workoutPlanItem.workouts)
        workoutProgressLabel = "M"
    }

    func displaySupersetWorkout(workoutPlanItem: WorkoutPlanItem) {
        workoutModeViewModel = WorkoutModeFormatter.formatSupersetWorkoutMode(workouts: workoutPlanItem.workouts)
        workoutProgressLabel = "A"
    }

    func displayTestWorkout(workoutPlanItem: WorkoutPlanItem) {
        guard let workout = workoutPlanItem.workouts.first else {
            // TODO: show error
            return
        }
        workoutModeViewModel = WorkoutModeFormatter.formatTestWorkoutMode(workout: workout)
    }

    func shouldShowOneRepMax(for workout: Workout) -> Bool {
        return workout.sets.contains(where: {
            if case .percentageOfMaximum = $0.targetWeight {
                return true
            } else {
                return false
            }
        })
    }

    func saveTapped() async {
        guard let url = URL(string: "https://workout-logger-backend.vercel.app/api/plans/\(workoutPlanItem.id)/add-log") else {
            print("Invalid URL")
            return
        }

        isLoading = true
        showError = false

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(workoutPlanItem)
            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response JSON: \(jsonResponse)")
            } else {
                print("JSON decoding failed but here is the response: \(String(data: data, encoding: .utf8))")
            }
        } catch {
            print("Error: \(error)")
            showError = true
        }
        isLoading = false
    }
}
