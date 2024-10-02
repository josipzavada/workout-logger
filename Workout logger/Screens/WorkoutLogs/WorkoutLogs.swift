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
                EmptyStateView(message: "You have no workout logs right now. Tap on Add new to add some.")
            } else {
                logItems
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            if viewModel.errorString == nil && !viewModel.isLoading {
                NavigationLink(value: NavigationState.newWorkoutLogView(workoutPlanItem: workoutPlanItem)) {
                    Text("Add new")
                }
                .buttonStyle(WorkoutLogButton())
            }
        }
        .task {
            await viewModel.fetchWorkoutLogs(planId: workoutPlanItem.id)
        }
        .background(Color(.Colors.paper))
        .navigationTitle("Logs")
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorString ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK"))
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
