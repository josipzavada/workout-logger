//
//  WorkoutPlanViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 01.10.2024..
//

import Foundation

struct WorkoutPlanItemViewModel: Identifiable {
    var id = UUID()
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
            let (data, response) = try await URLSession.shared.data(for: request)
            let workoutPlans = try JSONDecoder().decode([WorkoutPlanItem].self, from: data)
            workoutPlanItemsViewModels = workoutPlans.map({ workoutPlanItem in
                return WorkoutPlanItemViewModel(title: workoutPlanItem.type.rawValue, description: "description")
            })
            isLoading = false
        } catch {
            errorString = "Something went wrong. Please try again later"
        }
    }
}
