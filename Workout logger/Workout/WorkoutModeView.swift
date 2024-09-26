//
//  WorkoutModeView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutModeView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("EMOM")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 1)
                .foregroundStyle(Color(.Colors.paperDark))
            HStack {
                Image(systemName: "repeat")
                Text("EMOM 12 rounds")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color(.Colors.Text._60))
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 8) {
                WorkoutView()
                WorkoutView()
                WorkoutView()
            }
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
