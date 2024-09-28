//
//  WorkoutResultView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutResultsView: View {

    let valueUnit: VolumeUnit

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

            WorkoutInputViewHeader(volumeUnit: valueUnit.name, showWeight: true)
            WorkoutResultRowWithWeight(targetValue: 4, targetWeight: 60, value: 5, weight: 60)
            WorkoutResultRowWithWeight(targetValue: 4, targetWeight: 60, value: 5, weight: 40)
            WorkoutResultRow(targetValue: 4, value: 5)
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
