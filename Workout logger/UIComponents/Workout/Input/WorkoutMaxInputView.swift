//
//  WorkoutMaxInputView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutMaxInputView: View {
    let title: String
    @Binding var maxValue: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(title) \(Constants.WorkoutLog.oneRepMaxSuffix)")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            
            Divider()
                .background(Color(.Colors.paperDark))

            Text(Constants.WorkoutLog.weight)
                .font(.system(size: 13))
                .foregroundStyle(Color(.Colors.Text._40))
            
            WorkoutInputTextField(
                placeholder: "0",
                unit: Constants.WorkoutLog.kg,
                targetAchieved: .constant(false),
                value: $maxValue
            )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .roundedStrokeOverlay()
    }
}
