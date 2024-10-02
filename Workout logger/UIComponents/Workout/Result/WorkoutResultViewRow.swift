//
//  WorkoutResultViewRow.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutResultRowWithWeight: View {

    let set: Int
    let targetValue: WorkoutTarget
    let targetWeight: WorkoutTarget?
    let oneRepMax: Int?
    let value: Int?
    let weight: Int?

    private var targetAchieved = false
    private var targetWeightAchieved = false
    private var targetValueAchieved = false

    private let successColor = Color(.Colors.success)

    init(set: Int, targetValue: WorkoutTarget, targetWeight: WorkoutTarget? = nil, oneRepMax: Int? = nil, value: Int? = nil, weight: Int? = nil) {
        self.set = set
        self.targetValue = targetValue
        self.targetWeight = targetWeight
        self.oneRepMax = oneRepMax
        self.value = value
        self.weight = weight

        targetValueAchieved = value.map { targetValue.targetAchieved(value: $0, oneRepMax: oneRepMax) } ?? false
        targetWeightAchieved = weight.flatMap { w in targetWeight?.targetAchieved(value: w, oneRepMax: oneRepMax) } ?? false
        targetAchieved = targetWeight == nil ? targetValueAchieved : (targetValueAchieved && targetWeightAchieved)
    }

    var body: some View {

        HStack(spacing: 8) {
            HStack {
                Text(String(set))
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let value {
                    Text(String(value))
                        .foregroundStyle(targetValueAchieved ? .green : .black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 8) {

                if let weight {
                    Text(String(weight))
                        .foregroundStyle(targetWeightAchieved ? .green : .black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 0)

                Image(systemName: Constants.SystemImages.checkmark)
                    .frame(width: 40, height: 40)
                    .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
    }
}
