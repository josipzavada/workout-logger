//
//  WorkoutLogItem.swift
//  Workout logger
//
//  Created by Josip Zavada on 02.10.2024..
//

import SwiftUI

struct WorkoutLogItem: View {
    let viewModel: WorkoutLogItemViewModel

    var body: some View {
        NavigationLink(value: NavigationState.singleWorkoutLogView(workoutPlanItem: viewModel.workoutPlanItem)) {
            HStack {
                workoutAndDescriptionView
                Spacer(minLength: 0)
                Image(systemName: Constants.SystemImages.chevronRight)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .roundedStrokeOverlay()
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainWorkoutLogButton())
    }

    private var workoutAndDescriptionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .foregroundColor(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            Text(viewModel.description)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(.Colors.Text._60))
        }
    }
}
