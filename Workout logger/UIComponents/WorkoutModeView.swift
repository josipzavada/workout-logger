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
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .foregroundColor(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            
            Divider()
                .background(Color(.Colors.paperDark))
            
            if let target = viewModel.target {
                targetView(target)
            }
            
            workoutPreviewsView
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .roundedStrokeOverlay()
        .padding(.vertical, 4)
    }
    
    private func targetView(_ target: String) -> some View {
        HStack {
            Image(systemName: Constants.SystemImages.repeatText)
            Text(target)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(Color(.Colors.Text._60))
    }
    
    private var workoutPreviewsView: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.workoutPreviews) { workoutPreview in
                WorkoutView(target: workoutPreview.target, name: workoutPreview.name)
            }
        }
    }
}
