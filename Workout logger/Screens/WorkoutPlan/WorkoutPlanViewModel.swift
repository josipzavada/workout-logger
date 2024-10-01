//
//  WorkoutPlanViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 01.10.2024..
//

import Foundation

struct WorkoutPlanItemViewModel: Identifiable {
    let id: Int
    let workoutPlanItem: WorkoutPlanItem
    let title: String
    let description: String
}

@MainActor
class WorkoutPlanViewModel: ObservableObject {

    @Published var isLoading = true
    @Published var errorString: String?
    @Published var workoutPlanItemsViewModels = [WorkoutPlanItemViewModel]()

    func fetchPlanItems() async {
        guard let url = URL(string: "https://workout-logger-backend.vercel.app/api/plans") else { return }
        isLoading = true
        errorString = nil
        workoutPlanItemsViewModels = []
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let workoutPlans = try JSONDecoder().decode([WorkoutPlanItem].self, from: data)
            workoutPlanItemsViewModels = workoutPlans.map({ workoutPlanItem in
                let firstWorkout = workoutPlanItem.workouts.first
                let description = switch workoutPlanItem.type {
                case .emom:
                    WorkoutModeFormatter.formatEmomTarget(workouts: workoutPlanItem.workouts)
                case .pyramid:
                    firstWorkout != nil ? WorkoutModeFormatter.formatPyramidTarget(workout: firstWorkout!) : ""
                case .superset:
                    WorkoutModeFormatter.formatSupersetTarget(workouts: workoutPlanItem.workouts)
                case .test:
                    firstWorkout != nil ? WorkoutModeFormatter.formatTestTarget(workout: firstWorkout!) : ""
                }
                return WorkoutPlanItemViewModel(id: workoutPlanItem.id, workoutPlanItem: workoutPlanItem, title: workoutPlanItem.type.rawValue.capitalized, description: description)
            })
            isLoading = false
        } catch {
            errorString = "Something went wrong. Please try again later"
        }
    }
}
