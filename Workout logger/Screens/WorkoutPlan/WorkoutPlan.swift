//
//  WorkoutPlan.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutItem: View {
    let title: String
    let description: String

    var body: some View {
        NavigationLink(value: NavigationState.workoutLogsView) {
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
            Text(title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "repeat")
                Text(description)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color(.Colors.Text._60))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WorkoutPlan: View {

    @StateObject private var viewModel = WorkoutPlanViewModel()
    @State var navigationPath = [NavigationState]()

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                    WorkoutItem(title: planItemViewModel.title, description: planItemViewModel.description)
                }
            }
            .padding(12)
            .navigationDestination(for: NavigationState.self) { navigationState in
                switch navigationState {
                case .workoutLogsView:
                    WorkoutLogs()
                case .singleWorkoutLogView:
                    WorkoutLogView()
                case .newWorkoutLogView:
                    NewWorkoutLogView()
                }
            }
        }
    }
}

#Preview {
    WorkoutPlan()
}
