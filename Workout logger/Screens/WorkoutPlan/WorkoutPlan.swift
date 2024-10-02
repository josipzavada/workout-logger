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
            workoutItemButtonLabel
        }
        .buttonStyle(PlainWorkoutLogButton())
    }

    var workoutItemButtonLabel: some View {
        HStack {
            workoutAndDescriptionView
            Image(systemName: "chevron.right")
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .roundedStrokeOverlay()
        .padding(.vertical, 4)
    }

    var workoutAndDescriptionView: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "repeat")
                Text(viewModel.description)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color(.Colors.Text._60))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WorkoutPlan: View {

    @StateObject private var viewModel = WorkoutPlanViewModel()
    @StateObject var navigationPathModel = NavigationPathModel()

    var body: some View {
        NavigationStack(path: $navigationPathModel.path) {
            Group {
                if viewModel.isLoading {
                    progressView
                } else if let errorString = viewModel.errorString {
                    emptyStateView
                } else if viewModel.workoutPlanItemsViewModels.isEmpty {
                    errorView
                } else {
                    planItems
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.Colors.paper))
            .navigationTitle("My workout plan")
        }
        .task {
            await viewModel.fetchPlanItems()
        }
        .tint(.black)
        .environmentObject(navigationPathModel)
    }

    var progressView: some View {
        ProgressView()
    }

    var emptyStateView: some View {
        Text("You currently have no workout plans. Ask your trainer to add some.")
    }

    var errorView: some View {
        Text("An error occured. Please try again later.")
    }

    var planItems: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.workoutPlanItemsViewModels) { planItemViewModel in
                    WorkoutItem(viewModel: planItemViewModel)
                }
            }
            .padding(12)
            .navigationDestination(for: NavigationState.self) { navigationState in
                switch navigationState {
                case .workoutLogsView(let workoutPlanItem):
                    WorkoutLogsView(workoutPlanItem: workoutPlanItem)
                case .singleWorkoutLogView(let workoutPlanItem):
                    WorkoutLogView(workoutPlanItem: workoutPlanItem)
                case .newWorkoutLogView(let workoutPlanItem):
                    let viewModel = NewWorkoutLogViewModel(workoutPlanItem: workoutPlanItem)
                    NewWorkoutLogView(viewModel: viewModel)
                }
            }
        }
    }
}

//#Preview {
//    WorkoutPlan()
//}
