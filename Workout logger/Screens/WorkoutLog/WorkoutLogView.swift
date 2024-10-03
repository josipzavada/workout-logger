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
                workoutModeView
                maxViews
                workoutResultsViews
            }
            .padding(12)
        }
        .background(Color(.Colors.paper))
        .navigationTitle(Constants.WorkoutLog.log)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var workoutModeView: some View {
        if let workoutPreviewViewModel = viewModel.workoutModeViewModel {
            WorkoutModeView(viewModel: workoutPreviewViewModel)
        }
    }

    private var maxViews: some View {
        ForEach(Array(viewModel.workouts.enumerated()), id: \.offset) { index, workout in
            if viewModel.shouldShowOneRepMax(for: workout), let oneRepMax = workout.oneRepMax {
                WorkoutMaxView(title: workout.name, maxValue: oneRepMax)
            }
        }
    }

    private var workoutResultsViews: some View {
        ForEach(Array(viewModel.workouts.enumerated()), id: \.offset) { index, workout in
            WorkoutResultsView(
                workoutName: workout.name,
                volumeUnit: workout.volumeUnit,
                workout: workout,
                isLastInWorkoutPath: isLastInWorkoutPath(for: index),
                workoutPathLabel: workoutPathLabel(for: index)
            )
        }
    }

    private func isLastInWorkoutPath(for index: Int) -> Bool? {
        viewModel.workoutProgressLabel != nil
            ? WorkoutModeFormatter.isLastInWorkoutPath(index: index, numberOfWorkouts: viewModel.workouts.count)
            : nil
    }

    private func workoutPathLabel(for index: Int) -> String {
        "\(viewModel.workoutProgressLabel ?? "")\(index + 1)"
    }
}
