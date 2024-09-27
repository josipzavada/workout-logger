//
//  WorkoutLogView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

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

struct WorkoutResultsView: View {
    @State private var sets: Int = 5
    @State private var weight: Int = 12
    @State private var topSet: Int = 1

    var superSetOrder: SuperSetOrder = .none

    var body: some View {
        HStack(spacing: 4) {
            inputCard
                .padding(.vertical, 4)

            if (superSetOrder != .none) {
                workoutPath
            }
        }
    }

    @ViewBuilder
    var inputCard: some View {
        VStack(spacing: 12) {
            Text("Pull-ups")
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .foregroundStyle(Color(.Colors.paperDark))

            WorkoutInputViewHeader(showWeight: true)
            WorkoutResultRowWithWeight(targetValue: 4, targetWeight: 60, value: 5, weight: 60)
            WorkoutResultRowWithWeight(targetValue: 4, targetWeight: 60, value: 5, weight: 60)
            WorkoutResultRowWithWeight(targetValue: 4, targetWeight: 60, value: 5, weight: 60)
            Divider()
            HStack(spacing: 8){
                Text("Top set:")
                    .font(.system(size: 15))
                Text(String(topSet))
                    .font(.system(size: 20, weight: .bold))
            }
                .frame(maxWidth: .infinity, alignment: .leading)
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

    @ViewBuilder
    var workoutPath: some View {

        let isFirst = superSetOrder == .first
        let isLast = superSetOrder == .last

        VStack {
            if (!isFirst) {
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3]))
                    .frame(width: 1, height: 20)
                    .foregroundColor(Color(.Colors.neutralLine))
                    .padding(.top, 2)
            } else {
                Rectangle()
                    .opacity(0)
                    .frame(width: 1, height: 15)

            }
            Text("M1")
                .font(.system(size: 13))
                .opacity(0.3)
                .padding(6)
                .background(Color(.Colors.paperDark))
                .clipShape(.circle)
            if (!isLast) {
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3]))
                    .frame(width: 1)
                    .foregroundColor(Color(.Colors.neutralLine))
            } else {
                Rectangle()
                    .frame(width: 1)
                    .opacity(0)
            }
        }
    }
}


struct WorkoutMaxView: View {

    @State private var maxValue = 0

    var body: some View {
        VStack(spacing: 12) {
            Text("1RM")
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
            Text("100 kg")
                .frame(maxWidth: .infinity, alignment: .leading)
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

struct WorkoutLogView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    WorkoutModeView()
                    WorkoutMaxView()
                    WorkoutResultsView()
                }
                .padding(12)
            }
            .frame(maxHeight: .infinity)
            Button {
                print("Saved")
            } label: {
                Text("Save")
            }
            .buttonStyle(WorkoutLogButton())

        }
        .background(Color(.Colors.paper))
        .navigationTitle("New log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WorkoutLogView()
}
