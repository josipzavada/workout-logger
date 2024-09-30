//
//  WorkoutModeView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutModeView: View {

    let viewModel: WorkoutModeViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 1)
                .foregroundStyle(Color(.Colors.paperDark))
            if let target = viewModel.target {
                HStack {
                    Image(systemName: "repeat")
                    Text(target)
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(Color(.Colors.Text._60))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 8) {
                ForEach(viewModel.workoutPreviews) { workoutPreview in
                    WorkoutView(target: workoutPreview.target, name: workoutPreview.name)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .roundedStrokeOverlay()
        .padding(.vertical, 4)
    }
}
