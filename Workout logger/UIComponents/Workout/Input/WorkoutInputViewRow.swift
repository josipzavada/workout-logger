//
//  WorkoutInputViewRow.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct WorkoutInputViewHeader: View {
    let volumeUnit: String
    let showWeight: Bool
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                VStack {
                    Text("Sets")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text(volumeUnit.capitalized)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            if (showWeight) {
                Text("Weight")
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.system(size: 13))
        .foregroundStyle(Color(.Colors.Text._40))
    }
}

struct WorkoutInputRowWithWeight: View {
    let set: Int
    let targetValue: WorkoutTarget
    let targetWeight: WorkoutTarget?
    @Binding var oneRepMax: Int?
    @Binding var value: Int?
    @Binding var weight: Int?

    @State private var targetAchieved = false
    @State private var targetWeightAchieved = false
    @State private var targetValueAchieved = false

    private let successColor = Color(.Colors.success)

    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text(String(set))
                    .frame(maxWidth: .infinity, alignment: .leading)
                WorkoutInputTextField(placeholder: "12", targetAchieved: $targetValueAchieved, value: $value)
                    .onChange(of: value) {
                        checkIfTargetAchieved()
                    }
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 8) {
                if targetWeight != nil {
                    WorkoutInputTextField(placeholder: "12", unit: "kg", targetAchieved: $targetWeightAchieved, value: $weight)
                        .onChange(of: weight) {
                            checkIfTargetAchieved()
                        }
                }

                Image(systemName: "checkmark")
                    .frame(width: 40, height: 40)
                    .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
                    .clipShape(.rect(cornerRadius: 8))

            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    // TODO
    private func checkIfTargetAchieved() {

        if let value {
            targetValueAchieved = switch targetValue {
            case .maximum:
                true
            case .percentageOfMaximum(let percentage):
                Double(value) >= (Double(percentage) / 100.0) * Double(oneRepMax ?? 0)
            case .exact(let exactTarget):
                value >= exactTarget
            case .interval(let minTarget, let maxTarget):
                value >= minTarget && value <= maxTarget
            }
        } else {
            targetValueAchieved = false
        }

        if let weight {
            targetWeightAchieved = switch targetWeight {
            case .maximum:
                true
            case .percentageOfMaximum(let percentage):
                Double(weight) >= (Double(percentage) / 100.0) * Double(oneRepMax ?? 0)
            case .exact(let exactTarget):
                weight >= exactTarget
            case .interval(let minTarget, let maxTarget):
                weight >= minTarget && weight <= maxTarget
            case .none:
                true
            }
        } else {
            targetWeightAchieved = false
        }

        if targetWeight == nil {
            targetAchieved = targetValueAchieved
        } else {
            targetAchieved = targetValueAchieved && targetWeightAchieved
        }
    }
}

struct WorkoutInputTextField: View {
    let placeholder: String
    var unit: String? = nil
    @Binding var targetAchieved: Bool
    @Binding var value: Int?

    private let successTextBorderColor = Color(.Colors.green40)
    private let successTextBackground = Color(.Colors.green20)

    var body: some View {
        HStack(spacing: 4) {
            TextField(placeholder, value: $value, formatter: NumberFormatter())
            if let unit {
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(.Colors.Text._40))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(targetAchieved ? successTextBackground : .white))
        .clipShape(.rect(cornerRadius: 8))
        .roundedStrokeOverlay(
            cornerRadius: 8,
            strokeColor: Color(targetAchieved ? successTextBorderColor : .Colors.neutralG20),
            lineWidth: 2
        )
    }
}
