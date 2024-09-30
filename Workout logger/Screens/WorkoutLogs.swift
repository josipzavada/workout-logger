//
//  WorkoutLogs.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogItem: View {
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        NavigationLink(destination: WorkoutLogView()) {
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
            Text(title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            Text(description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(.Colors.Text._60))
        }
    }
}

struct WorkoutLogs: View {

    private let dateFormatter: DateFormatter
    private let timeformatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        timeformatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        timeformatter.dateFormat = "h:mm a"
    }

    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    WorkoutLogItem(title: dateFormatter.string(from: Date()), description: timeformatter.string(from: Date())) {
                        print("asdf")
                    }
                    WorkoutLogItem(title: dateFormatter.string(from: Date()), description: timeformatter.string(from: Date())) {
                        print("asdf")
                    }
                    WorkoutLogItem(title: dateFormatter.string(from: Date()), description: timeformatter.string(from: Date())) {
                        print("asdf")
                    }
                    WorkoutLogItem(title: dateFormatter.string(from: Date()), description: timeformatter.string(from: Date())) {
                        print("asdf")
                    }
                }
                .padding(12)
            }.safeAreaInset(edge: .bottom) {
                NavigationLink(destination: NewWorkoutLogView()) {
                    Text("Add new")
                }
                .buttonStyle(WorkoutLogButton())
            }
        .background(Color(.Colors.paper))
        .navigationTitle("Logs")
    }
}

#Preview {
    WorkoutLogs()
}
