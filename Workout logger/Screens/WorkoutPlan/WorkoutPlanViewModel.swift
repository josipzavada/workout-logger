//
//  WorkoutPlanViewModel.swift
//  Workout logger
//
//  Created by Josip Zavada on 01.10.2024..
//

import Foundation

class WorkoutPlanViewModel: ObservableObject {

    func fetchPlanItems() async throws {
        print("Fetching")
        guard let url = URL(string: "https://workout-logger-backend.vercel.app/api/plans") else { return }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        print(String(data: data, encoding: .utf8))
        let workoutPlans = try JSONDecoder().decode([WorkoutPlanItem].self, from: data)
        print(workoutPlans)
    }
}
