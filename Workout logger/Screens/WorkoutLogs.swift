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
        Button {
            action()
        } label: {
            workoutItemButtonLabel
        }
        .buttonStyle(PlainWorkoutLogButton())
    }

    @ViewBuilder
    var workoutItemButtonLabel: some View {
        HStack {
            workoutAndDescriptionView
            Image(systemName: "chevron.right")
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.Colors.paperDark), lineWidth: 1)
        )
        .padding(.vertical, 4)
    }

    @ViewBuilder
    var workoutAndDescriptionView: some View {
        VStack(spacing: 12) {
            Text(title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(.Colors.Text._60))
                .frame(maxWidth: .infinity, alignment: .leading)
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
        VStack {
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
            }
            .frame(maxHeight: .infinity)
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
