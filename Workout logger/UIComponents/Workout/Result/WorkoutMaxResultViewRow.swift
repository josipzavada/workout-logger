//
//  WorkoutMaxResultViewRow.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutMaxView: View {

    let title: String
    let maxValue: Int

    var body: some View {
        VStack(spacing: 12) {
            Text("\(title) \(Constants.WorkoutLog.oneRepMaxSuffix)")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .foregroundStyle(Color(.Colors.paperDark))

            Text(Constants.WorkoutLog.weight)
                .font(.system(size: 13))
                .foregroundStyle(Color(.Colors.Text._40))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(maxValue) \(Constants.WorkoutLog.kg)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .roundedStrokeOverlay()
    }
}
