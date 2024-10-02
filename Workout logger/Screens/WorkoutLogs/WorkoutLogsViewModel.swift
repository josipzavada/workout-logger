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
    @Published private(set) var isLoading = false
    @Published private(set) var errorString: String?
    @Published private(set) var workoutLogItemViewModels = [WorkoutLogItemViewModel]()
    @Published var showErrorAlert = false
    
    private let networkService: NetworkServiceProtocol
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "d.M.yyyy."
        
        self.timeFormatter = DateFormatter()
        self.timeFormatter.dateFormat = "h:mm a"
    }

    func fetchWorkoutLogs(planId: Int) async {
        isLoading = true
        errorString = nil
        workoutLogItemViewModels.removeAll()
        
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

        let formattedDate = dateFormatter.string(from: workoutLogDate)
        let formattedTime = timeFormatter.string(from: workoutLogDate)

        return WorkoutLogItemViewModel(
            title: formattedDate,
            description: formattedTime,
            workoutPlanItem: workoutLog
        )
    }
}
