//
//  WorkoutLogs.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogItem: View {
    let viewModel: WorkoutLogItemViewModel

    var body: some View {
        NavigationLink(value: NavigationState.singleWorkoutLogView(workoutPlanItem: viewModel.workoutPlanItem)) {
            workoutItemButtonLabel
        }
        .buttonStyle(PlainWorkoutLogButton())
    }

    var workoutItemButtonLabel: some View {
        HStack {
            workoutAndDescriptionView
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
        }
        .padding(16)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .roundedStrokeOverlay()
        .padding(.vertical, 4)
    }

    var workoutAndDescriptionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            Text(viewModel.description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(.Colors.Text._60))
        }
    }
}

struct WorkoutLogs: View {

    private let planId: Int
    @StateObject private var viewModel = WorkoutLogsViewModel()

    init(planId: Int) {
        self.planId = planId
    }

    var body: some View {

        Group {
            if viewModel.isLoading {
                progressView
            } else if let errorString = viewModel.errorString {
                errorView(errorString: errorString)
            } else if viewModel.workoutLogItemViewModels.isEmpty {
                emptyStateView
            } else {
                logItems
            }
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.errorString == "" {
                NavigationLink(value: NavigationState.newWorkoutLogView) {
                    Text("Add new")
                }
                .buttonStyle(WorkoutLogButton())
            }
        }
        .task {
            await viewModel.fetchWorkoutLogs(planId: planId)
        }
        .background(Color(.Colors.paper))
        .navigationTitle("Logs")
    }

    var progressView: some View {
        ProgressView()
    }

    var emptyStateView: some View {
        Text("You currently have no workout logs. Tap on Add new to add some.")
    }

    func errorView(errorString: String) -> some View {
        return Text(errorString)
    }

    var logItems: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.workoutLogItemViewModels) {
                    WorkoutLogItem(viewModel: $0)
                }
            }
            .padding(12)
        }
    }
}

#Preview {
    WorkoutLogs(planId: 2)
}
