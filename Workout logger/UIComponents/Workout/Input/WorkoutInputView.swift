//
//  WorkoutInputView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

enum SuperSetOrder {
    case first
    case last
    case middle
    case none
}

struct WorkoutInputView: View {

    @Binding var workoutSetLogs: [WorkoutSetLog]
    @State var topSet: Int = 1

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

            let shouldHideWeight = workoutSetLogs.allSatisfy { $0.targetWeight == nil }
            WorkoutInputViewHeader(showWeight: !shouldHideWeight)

            ForEach(workoutSetLogs.indices, id: \.self) { index in
                WorkoutInputRowWithWeight(
                    set: index + 1,
                    targetValue: workoutSetLogs[index].targetVolume,
                    targetWeight: workoutSetLogs[index].targetWeight,
                    value: $workoutSetLogs[index].volume,
                    weight: $workoutSetLogs[index].weight
                )
            }

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

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
