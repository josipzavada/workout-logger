//
//  WorkoutInputView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

enum WorkoutPathOrder {
    case first, last, middle, none
}

struct WorkoutInputView: View {
    let workoutName: String
    let valueUnit: VolumeUnit
    @Binding var workout: Workout
    @State private var topSetIndex: Int? = nil

    var workoutPathOrder: WorkoutPathOrder = .none
    var workoutPathLabel: String = ""

    var body: some View {
        HStack(spacing: 4) {
            inputCard
            if workoutPathOrder != .none {
                workoutPath
            }
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(workoutName)
                .foregroundStyle(Color(.Colors.Text._100))
                .font(.system(size: 19, weight: .bold))
            
            Divider().foregroundStyle(Color(.Colors.paperDark))

            WorkoutInputViewHeader(volumeUnit: valueUnit.name, showWeight: !shouldHideWeight)

            ForEach(Array(workout.sets.enumerated()), id: \.offset) { index, workoutSet in
                WorkoutInputRowWithWeight(
                    set: index + 1,
                    targetValue: workoutSet.targetVolume,
                    targetWeight: workoutSet.targetWeight,
                    oneRepMax: $workout.oneRepMax,
                    value: $workout.sets[index].volume,
                    weight: $workout.sets[index].weight
                )
            }
            .onChange(of: workout) { updateTopSet() }

            if let topSetIndex {
                Divider()
                HStack(spacing: 8) {
                    Text(Constants.WorkoutLog.topSet)
                        .font(.system(size: 15))
                    Text(String(topSetIndex + 1))
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .roundedStrokeOverlay()
        .padding(.vertical, 4)
    }

    private var workoutPath: some View {
        VStack {
            if workoutPathOrder != .first {
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3]))
                    .frame(width: 1, height: 20)
                    .foregroundColor(Color(.Colors.neutralLine))
                    .padding(.top, 2)
            } else {
                Color.clear.frame(width: 1, height: 15)
            }
            
            Text(workoutPathLabel)
                .font(.system(size: 13))
                .opacity(0.3)
                .padding(6)
                .background(Color(.Colors.paperDark))
                .clipShape(Circle())
            
            if workoutPathOrder != .last {
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3]))
                    .frame(width: 1)
                    .foregroundColor(Color(.Colors.neutralLine))
            } else {
                Color.clear.frame(width: 1)
            }
        }
    }

    private var shouldHideWeight: Bool {
        workout.sets.allSatisfy { $0.targetWeight == nil }
    }

    private func updateTopSet() {
        topSetIndex = workout.bestSetIndex()
    }
}
