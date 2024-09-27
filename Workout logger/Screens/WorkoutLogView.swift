//
//  WorkoutLogView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    WorkoutModeView()
                    WorkoutMaxView()
                    WorkoutResultsView()
                }
                .padding(12)
            }
            .frame(maxHeight: .infinity)
            Button {
                print("Saved")
            } label: {
                Text("Save")
            }
            .buttonStyle(WorkoutLogButton())

        }
        .background(Color(.Colors.paper))
        .navigationTitle("New log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WorkoutLogView()
}
