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
        VStack(spacing: 12) {
            Text("\(title) 1RM")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 1)
                .foregroundStyle(Color(.Colors.paperDark))

            Text("Weight")
                .font(.system(size: 13))
                .foregroundStyle(Color(.Colors.Text._40))
                .frame(maxWidth: .infinity, alignment: .leading)
            WorkoutInputTextField(placeholder: "0", unit: "kg", targetAchieved: .constant(false), value: $maxValue)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.Colors.paperDark), lineWidth: 1)
        )
    }
}
