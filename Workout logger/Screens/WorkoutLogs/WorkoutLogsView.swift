//
//  WorkoutLogs.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogsView: View {

    private let workoutPlanItem: WorkoutPlanItem
    @StateObject private var viewModel = WorkoutLogsViewModel()

    init(workoutPlanItem: WorkoutPlanItem) {
        self.workoutPlanItem = workoutPlanItem
    }

    var body: some View {

        Group {
            if viewModel.isLoading {
                progressView
            } else if viewModel.workoutLogItemViewModels.isEmpty {
                EmptyStateView(message: Constants.WorkoutLog.emptyStateMessage)
            } else {
                logItems
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            if viewModel.errorString == nil && !viewModel.isLoading {
                NavigationLink(value: NavigationState.newWorkoutLogView(workoutPlanItem: workoutPlanItem)) {
                    Text(Constants.WorkoutLog.addNew)
                }
                .buttonStyle(WorkoutLogButton())
            }
        }
        .task {
            await viewModel.fetchWorkoutLogs(planId: workoutPlanItem.id)
        }
        .background(Color(.Colors.paper))
        .navigationTitle(Constants.WorkoutLog.logs)
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text(Constants.General.error),
                message: Text(viewModel.errorString ?? Constants.WorkoutPlan.errorMessage),
                dismissButton: .default(Text(Constants.General.ok))
            )
        }
    }

    var progressView: some View {
        ProgressView()
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

//#Preview {
//    WorkoutLogs(planId: 2)
//}
