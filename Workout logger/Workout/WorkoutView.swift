//
//  WorkoutView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("12")
                .foregroundStyle(Color(.Colors.Text._40))
            Text("Pull-ups")
                .foregroundStyle(Color(.Colors.Text._100))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.Colors.neutralG20))
        .clipShape(.rect(cornerRadius: 6))
    }
}
