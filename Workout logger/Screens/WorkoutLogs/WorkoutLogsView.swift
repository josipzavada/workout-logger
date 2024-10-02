//
//  WorkoutLogs.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

// Define a custom environment key
struct RefreshWorkoutLogsKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

// Extend EnvironmentValues to include our custom key
extension EnvironmentValues {
    var refreshWorkoutLogs: Binding<Bool> {
        get { self[RefreshWorkoutLogsKey.self] }
        set { self[RefreshWorkoutLogsKey.self] = newValue }
    }
}

struct WorkoutLogsView: View {
    private let workoutPlanItem: WorkoutPlanItem
    @StateObject private var viewModel = WorkoutLogsViewModel()
    @State private var hasAppeared = false
    @EnvironmentObject var navigationPathModel: NavigationPathModel

    init(workoutPlanItem: WorkoutPlanItem) {
        self.workoutPlanItem = workoutPlanItem
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, content: bottomButton)
            .task {
                if !hasAppeared || navigationPathModel.shouldRefreshWorkoutLogs {
                    await viewModel.fetchWorkoutLogs(planId: workoutPlanItem.id)
                    navigationPathModel.shouldRefreshWorkoutLogs = false
                    hasAppeared = true
                }
            }
            .background(Color(.Colors.paper))
            .navigationTitle(Constants.WorkoutLog.logs)
            .alert(isPresented: $viewModel.showErrorAlert, content: errorAlert)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.workoutLogItemViewModels.isEmpty {
            EmptyStateView(message: Constants.WorkoutLog.emptyStateMessage)
        } else {
            logItems
        }
    }

    @ViewBuilder
    private func bottomButton() -> some View {
        if viewModel.errorString == nil && !viewModel.isLoading {
            NavigationLink(value: NavigationState.newWorkoutLogView(workoutPlanItem: workoutPlanItem)) {
                Text(Constants.WorkoutLog.addNew)
            }
            .buttonStyle(WorkoutLogButton())
        }
    }

    private var logItems: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.workoutLogItemViewModels) { viewModel in
                    WorkoutLogItem(viewModel: viewModel)
                }
            }
            .padding(12)
        }
    }

    private func errorAlert() -> Alert {
        Alert(
            title: Text(Constants.General.error),
            message: Text(viewModel.errorString ?? Constants.WorkoutPlan.errorMessage),
            dismissButton: .default(Text(Constants.General.ok))
        )
    }
}

//#Preview {
//    WorkoutLogs(planId: 2)
//}
