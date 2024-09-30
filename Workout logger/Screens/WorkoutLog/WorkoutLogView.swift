//
//  WorkoutLogView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogView: View {
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
//                    WorkoutModeView()
                    WorkoutMaxView()
                    WorkoutResultsView(valueUnit: VolumeUnit.rep)
                }
                .padding(12)
            }
            Button {
                print("Saved")
            } label: {
                Text("Save")
            }
            .buttonStyle(WorkoutLogButton())

        }
        .background(Color(.Colors.paper))
        .navigationTitle("Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WorkoutLogView()
}
