//
//  WorkoutLogView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogView: View {

    let viewModel: WorkoutLogViewModel
    init(workoutPlanItem: WorkoutPlanItem) {
        self.viewModel = WorkoutLogViewModel(workoutPlanItem: workoutPlanItem)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let workoutPreviewViewModel = viewModel.workoutModeViewModel {
                    WorkoutModeView(viewModel: workoutPreviewViewModel)
                }
                ForEach(Array(viewModel.maxViews.enumerated()), id: \.offset) { index, maxViewModel in
                    if let maxViewModel {
                        WorkoutMaxView(viewModel: maxViewModel)
                    }
                }
                ForEach(Array(viewModel.workouts.enumerated()), id: \.offset) { (index, workout) in

                    let workoutPathOrder = WorkoutModeFormatter.workoutPathOrder(index: index, numberOfWorkouts: viewModel.workouts.count)

                    WorkoutResultsView(
                        workoutName: workout.name,
                        valueUnit: workout.volumeUnit,
                        workout: viewModel.workouts[index],
                        workoutPathOrder: viewModel.workoutProgressLabel != nil ? workoutPathOrder : .none,
                        workoutPathLabel: "\(viewModel.workoutProgressLabel ?? "")\(index + 1)"
                    )
                }
            }
            .padding(12)
        }
        .background(Color(.Colors.paper))
        .navigationTitle(Constants.WorkoutLog.log)
        .navigationBarTitleDisplayMode(.inline)
    }
}
