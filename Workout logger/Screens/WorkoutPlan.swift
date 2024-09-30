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
    let action: () -> Void

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

    @State var navigationPath = [NavigationState]()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 0) {
                    WorkoutItem(title: "EMOM", description: "EMOM 12 rounds") {
                        print("asdf")
                    }
                    WorkoutItem(title: "EMOM", description: "EMOM 12 rounds") {
                        print("asdf")
                    }
                    WorkoutItem(title: "EMOM", description: "EMOM 12 rounds") {
                        print("asdf")
                    }
                    WorkoutItem(title: "EMOM", description: "EMOM 12 rounds") {
                        print("asdf")
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
            .frame(maxHeight: .infinity)
            .background(Color(.Colors.paper))
            .navigationTitle("My workout plan")
        }
        .tint(.black)
    }
}

#Preview {
    WorkoutPlan()
}
