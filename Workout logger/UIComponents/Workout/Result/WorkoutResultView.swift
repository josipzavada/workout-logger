//
//  WorkoutResultView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutResultsView: View {
    let workoutName: String
    let valueUnit: VolumeUnit
    let workout: Workout
    var workoutPathOrder: WorkoutPathOrder = .none
    var workoutPathLabel: String = ""

    var body: some View {
        HStack(spacing: 4) {
            inputCard
                .padding(.vertical, 4)

            if (workoutPathOrder != .none) {
                workoutPath
            }
        }
    }

    var inputCard: some View {
        VStack(spacing: 12) {
            Text(workoutName)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .foregroundStyle(Color(.Colors.paperDark))

            let shouldHideWeight = workout.sets.allSatisfy { $0.targetWeight == nil }
            WorkoutInputViewHeader(volumeUnit: valueUnit.name, showWeight: !shouldHideWeight)

            ForEach(Array(workout.sets.enumerated()), id: \.offset) { (index, workoutSet) in
                WorkoutResultRowWithWeight(
                    set: index + 1,
                    targetValue: workoutSet.targetVolume,
                    targetWeight: workoutSet.targetWeight,
                    oneRepMax: workout.oneRepMax,
                    value: workout.sets[index].volume,
                    weight: workout.sets[index].weight
                )
            }

            if let topSet = workout.bestSetIndex() {
                Divider()
                HStack(spacing: 8){
                    Text("Top set:")
                        .font(.system(size: 15))
                    Text(String(topSet + 1))
                        .font(.system(size: 20, weight: .bold))
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .roundedStrokeOverlay()
    }

    @ViewBuilder
    var workoutPath: some View {

        let isFirst = workoutPathOrder == .first
        let isLast = workoutPathOrder == .last

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
            Text(workoutPathLabel)
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
