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
}

@MainActor
class WorkoutLogsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var errorString: String?
    @Published var workoutLogItemViewModels = [WorkoutLogItemViewModel]()

    func fetchWorkoutLogs(planId: Int) async {
        guard let url = URL(string: "https://workout-logger-backend.vercel.app/api/plans/\(planId)/workout-logs") else { return }
        isLoading = true
        errorString = nil
        workoutLogItemViewModels = []
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()

            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Handles milliseconds
            isoFormatter.locale = Locale(identifier: "en_US_POSIX")
            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            // Set the custom date decoding strategy
            decoder.dateDecodingStrategy = .formatted(isoFormatter)

            let workoutLogs = try decoder.decode([WorkoutPlanItem].self, from: data)

            workoutLogItemViewModels = workoutLogs.compactMap { workoutLog in

                guard let workoutLogDate = workoutLog.logDate else { return nil }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d.M.yyyy."
                let formattedDate = dateFormatter.string(from: workoutLogDate)

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                let formattedTime = timeFormatter.string(from: workoutLogDate)

                return WorkoutLogItemViewModel(title: formattedDate, description: formattedTime)
            }
        } catch {
            errorString = "Something went wrong. Please try again later"
            print(error)
        }
        isLoading = false
    }
}
