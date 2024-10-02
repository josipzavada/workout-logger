//
//  WorkoutPlan.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutItem: View {
    let viewModel: WorkoutPlanItemViewModel

    var body: some View {
        NavigationLink(value: NavigationState.workoutLogsView(workoutPlanItem: viewModel.workoutPlanItem)) {
            HStack {
                workoutAndDescriptionView
                Image(systemName: Constants.SystemImages.chevronRight)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .roundedStrokeOverlay()
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainWorkoutLogButton())
    }

    private var workoutAndDescriptionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            
            HStack {
                Image(systemName: Constants.SystemImages.repeatText)
                Text(viewModel.description)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color(.Colors.Text._60))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WorkoutPlan: View {
    @StateObject private var viewModel = WorkoutPlanViewModel()
    @StateObject private var navigationPathModel = NavigationPathModel()

    var body: some View {
        NavigationStack(path: $navigationPathModel.path) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.Colors.paper))
                .navigationTitle(Constants.WorkoutPlan.navigationTitle)
        }
        .task { await viewModel.fetchPlanItems() }
        .tint(.black)
        .environmentObject(navigationPathModel)
        .alert(isPresented: $viewModel.showErrorAlert, content: errorAlert)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.errorString != nil {
            Text(Constants.WorkoutPlan.emptyStateMessage)
        } else if viewModel.workoutPlanItemsViewModels.isEmpty {
            Text(Constants.WorkoutPlan.errorMessage)
        } else {
            planItems
        }
    }

    private var planItems: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.workoutPlanItemsViewModels) { planItemViewModel in
                    WorkoutItem(viewModel: planItemViewModel)
                }
            }
            .padding(12)
        }
        .navigationDestination(for: NavigationState.self, destination: destinationView)
    }

    @ViewBuilder
    private func destinationView(for state: NavigationState) -> some View {
        switch state {
        case .workoutLogsView(let workoutPlanItem):
            WorkoutLogsView(workoutPlanItem: workoutPlanItem)
        case .singleWorkoutLogView(let workoutPlanItem):
            WorkoutLogView(workoutPlanItem: workoutPlanItem)
        case .newWorkoutLogView(let workoutPlanItem):
            NewWorkoutLogView(viewModel: NewWorkoutLogViewModel(workoutPlanItem: workoutPlanItem))
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
//    WorkoutPlan()
//}
