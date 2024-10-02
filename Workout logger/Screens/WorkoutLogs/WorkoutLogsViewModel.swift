//
//  WorkoutLogsViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 01.10.2024..
//

import SwiftUI

struct WorkoutLogItemViewModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let workoutPlanItem: WorkoutPlanItem
}

@MainActor
class WorkoutLogsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var errorString: String?
    @Published var workoutLogItemViewModels = [WorkoutLogItemViewModel]()
    @Published var showErrorAlert = false
    
    private let networkService = NetworkService.shared

    func fetchWorkoutLogs(planId: Int) async {
        isLoading = true
        errorString = nil
        workoutLogItemViewModels = []
        
        do {
            let workoutLogs = try await networkService.fetchWorkoutLogs(planId: planId)
            workoutLogItemViewModels = workoutLogs.compactMap(createWorkoutLogItemViewModel)
        } catch {
            errorString = Constants.General.error
            showErrorAlert = true
        }
        isLoading = false
    }

    private func createWorkoutLogItemViewModel(from workoutLog: WorkoutPlanItem) -> WorkoutLogItemViewModel? {
        guard let workoutLogDate = workoutLog.logDate else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy."
        let formattedDate = dateFormatter.string(from: workoutLogDate)

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let formattedTime = timeFormatter.string(from: workoutLogDate)

        return WorkoutLogItemViewModel(title: formattedDate, description: formattedTime, workoutPlanItem: workoutLog)
    }
}
