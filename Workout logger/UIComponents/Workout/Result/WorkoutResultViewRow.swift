//
//  WorkoutResultViewRow.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutResultRow: View {
    let targetValue: Int
    let value: Int

    private let successColor = Color(.Colors.success)

    var body: some View {
        let targetValueAchieved = value >= targetValue
        HStack(spacing: 8) {
            HStack {
                Text("1")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(value))
                    .foregroundStyle(targetValueAchieved ? .green : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)

            Image(systemName: "checkmark")
                .frame(width: 40, height: 40)
                .background(Color(targetValueAchieved ? .Colors.success : .Colors.neutralG30))
                .clipShape(.rect(cornerRadius: 8))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct WorkoutResultRowWithWeight: View {
    let targetValue: Int
    let targetWeight: Int
    let value: Int
    let weight: Int

    private let successColor = Color(.Colors.success)

    var body: some View {
        let targetWeightAchieved = weight >= targetWeight
        let targetValueAchieved = value >= targetValue
        let targetAchieved = targetValueAchieved && targetWeightAchieved

        HStack(spacing: 8) {
            HStack {
                Text("1")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(value))
                    .foregroundStyle(targetValueAchieved ? .green : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 8) {
                Text(String(weight))
                    .foregroundStyle(targetWeightAchieved ? .green : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "checkmark")
                    .frame(width: 40, height: 40)
                    .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
                    .clipShape(.rect(cornerRadius: 8))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
