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
            headerText(Constants.WorkoutLog.sets)
            headerText(volumeUnit.capitalized)
            if showWeight {
                headerText(Constants.WorkoutLog.weight)
            } else {
                Spacer().frame(maxWidth: .infinity)
            }
        }
        .font(.system(size: 13))
        .foregroundStyle(Color(.Colors.Text._40))
    }
    
    private func headerText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
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

    @State private var weightPlaceholder = ""

    private let successColor = Color(.Colors.success)

    var body: some View {
        HStack(spacing: 8) {
            setAndValueInputs
            weightAndCheckmark
        }
        .onAppear(perform: updateWeightPlaceholder)
    }
    
    private var setAndValueInputs: some View {
        HStack {
            Text(String(set))
                .frame(maxWidth: .infinity, alignment: .leading)
            WorkoutInputTextField(
                placeholder: targetValue.textFieldPlaceholder(oneRepMax: nil),
                targetAchieved: $targetValueAchieved,
                value: $value
            )
            .onChange(of: value) { checkIfTargetAchieved() }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var weightAndCheckmark: some View {
        HStack(spacing: 8) {
            if targetWeight != nil {
                WorkoutInputTextField(
                    placeholder: weightPlaceholder,
                    unit: Constants.WorkoutLog.kg,
                    targetAchieved: $targetWeightAchieved,
                    value: $weight
                )
                .onChange(of: weight) { checkIfTargetAchieved() }
                .onChange(of: oneRepMax) {
                    updateWeightPlaceholder()
                    checkIfTargetAchieved()
                }
            }
            
            checkmarkImage
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var checkmarkImage: some View {
        Image(systemName: Constants.SystemImages.checkmark)
            .frame(width: 40, height: 40)
            .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
            .clipShape(.rect(cornerRadius: 8))
    }

    private func updateWeightPlaceholder() {
        weightPlaceholder = targetWeight?.textFieldPlaceholder(oneRepMax: oneRepMax) ?? ""
    }

    // TODO
    private func checkIfTargetAchieved() {

        if let value {
            targetValueAchieved = targetValue.targetAchieved(value: value, oneRepMax: oneRepMax)
        } else {
            targetValueAchieved = false
        }

        if let weight {
            targetWeightAchieved = targetWeight?.targetAchieved(value: weight, oneRepMax: oneRepMax) ?? false
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
                .keyboardType(.numberPad)
            if let unit = unit {
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(.Colors.Text._40))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 8))
        .roundedStrokeOverlay(
            cornerRadius: 8,
            strokeColor: strokeColor,
            lineWidth: 2
        )
    }
    
    private var backgroundColor: Color {
        targetAchieved ? successTextBackground : .white
    }
    
    private var strokeColor: Color {
        Color(targetAchieved ? successTextBorderColor : .Colors.neutralG20)
    }
}
