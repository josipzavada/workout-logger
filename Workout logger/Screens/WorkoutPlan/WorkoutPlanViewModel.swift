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
    @Published var showErrorAlert = false

    private let networkService = NetworkService.shared

    func fetchPlanItems() async {
        isLoading = true
        errorString = nil
        workoutPlanItemsViewModels = []
        
        do {
            let workoutPlans = try await networkService.fetchWorkoutPlans()
            workoutPlanItemsViewModels = workoutPlans.map(createWorkoutPlanItemViewModel)
            isLoading = false
        } catch {
            errorString = Constants.WorkoutPlan.fetchErrorMessage
            showErrorAlert = true
            print(error) // For debugging purposes
        }
    }

    private func createWorkoutPlanItemViewModel(from workoutPlanItem: WorkoutPlanItem) -> WorkoutPlanItemViewModel {
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
    }
}
