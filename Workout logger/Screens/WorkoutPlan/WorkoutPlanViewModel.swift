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
    @Published private(set) var isLoading = false
    @Published private(set) var errorString: String?
    @Published private(set) var workoutPlanItemsViewModels = [WorkoutPlanItemViewModel]()
    @Published var showErrorAlert = false

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchPlanItems() async {
        isLoading = true
        errorString = nil
        workoutPlanItemsViewModels.removeAll()
        
        do {
            let workoutPlans = try await networkService.fetchWorkoutPlans()
            workoutPlanItemsViewModels = workoutPlans.map(createWorkoutPlanItemViewModel)
        } catch {
            errorString = Constants.WorkoutPlan.fetchErrorMessage
            showErrorAlert = true
            #if DEBUG
            print("Error fetching workout plans: \(error)")
            #endif
        }
        
        isLoading = false
    }

    private func createWorkoutPlanItemViewModel(from workoutPlanItem: WorkoutPlanItem) -> WorkoutPlanItemViewModel {
        let description = getDescription(for: workoutPlanItem)
        return WorkoutPlanItemViewModel(
            id: workoutPlanItem.id,
            workoutPlanItem: workoutPlanItem,
            title: workoutPlanItem.type.rawValue.capitalized,
            description: description
        )
    }

    private func getDescription(for workoutPlanItem: WorkoutPlanItem) -> String {
        switch workoutPlanItem.type {
        case .emom:
            return WorkoutModeFormatter.formatEmomTarget(workouts: workoutPlanItem.workouts)
        case .pyramid, .test:
            return workoutPlanItem.workouts.first.map { workout in
                workoutPlanItem.type == .pyramid
                    ? WorkoutModeFormatter.formatPyramidTarget(workout: workout)
                    : WorkoutModeFormatter.formatTestTarget(workout: workout)
            } ?? ""
        case .superset:
            return WorkoutModeFormatter.formatSupersetTarget(workouts: workoutPlanItem.workouts)
        }
    }
}
