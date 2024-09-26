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

struct WorkoutInputViewWithWeightHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                VStack {
                    Text("Sets")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("Reps")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            VStack {
                Text("Weight")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WorkoutInputRowWithWeight: View {
    let targetValue: Int
    let targetWeight: Int
    @Binding var value: Int
    @Binding var weight: Int
    @State private var targetAchieved = false
    @State private var targetWeightAchieved = false
    @State private var targetValueAchieved = false

    private let successColor = Color(.Colors.success)

    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text("1")
                    .frame(maxWidth: .infinity, alignment: .leading)
                WorkoutInputTextField(placeholder: "12", targetAchieved: $targetValueAchieved, value: $value)
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 8) {
                WorkoutInputTextField(placeholder: "12", targetAchieved: $targetWeightAchieved, showKg: true, value: $weight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onChange(of: value) {
                        checkIfTargetAchieved()
                    }

                Image(systemName: "checkmark")
                    .frame(width: 40, height: 40)
                    .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
                    .clipShape(.rect(cornerRadius: 8))
                    .onChange(of: weight) {
                        checkIfTargetAchieved()
                    }

            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func checkIfTargetAchieved() {
        targetValueAchieved = value >= targetValue
        targetWeightAchieved = weight >= targetWeight
        targetAchieved = targetValueAchieved && targetWeightAchieved
    }
}

struct WorkoutInputTextField: View {
    let placeholder: String
    @Binding var targetAchieved: Bool
    var showKg: Bool = false
    @Binding var value: Int

    private let successTextBorderColor = Color(.Colors.green40)
    private let successTextBackground = Color(.Colors.green20)

    var body: some View {
        HStack(spacing: 4) {
            TextField(placeholder, value: $value, formatter: NumberFormatter())
            if showKg {
                Text("kg")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(.Colors.Text._40))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(targetAchieved ? successTextBackground : .white))
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(targetAchieved ? successTextBorderColor : .Colors.neutralG20), lineWidth: 2)
        )
    }
}
