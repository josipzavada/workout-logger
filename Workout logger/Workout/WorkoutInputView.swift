//
//  WorkoutInputView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutInputView: View {
    @State private var sets: Int = 5
    @State private var weight: Int = 12

    var body: some View {
        VStack(spacing: 12) {
            Text("Pull-ups")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 1)
                .foregroundStyle(Color(.Colors.paperDark))

            WorkoutInputViewWithWeightHeader()
            WorkoutInputRowWithWeight(targetValue: 4, targetWeight: 60, value: $sets, weight: $weight)
            WorkoutInputRow(targetValue: 4, value: $sets)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.Colors.paperDark), lineWidth: 1)
        )
    }
}
