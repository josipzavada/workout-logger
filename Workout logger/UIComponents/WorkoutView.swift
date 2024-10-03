//
//  WorkoutView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutView: View {

    let target: String?
    let name: String

    var body: some View {
        HStack(spacing: 4) {
            if let target {
                Text(target)
                    .foregroundColor(Color(.Colors.Text._40))
            }
            Text(name)
                .foregroundColor(Color(.Colors.Text._100))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.Colors.neutralG20))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
