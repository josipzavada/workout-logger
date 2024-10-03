//
//  WorkoutResultViewRow.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutResultRowWithWeight: View {
    let set: Int
    let targetVolume: WorkoutTarget
    let targetWeight: WorkoutTarget?
    let oneRepMax: Int?
    let volume: Int?
    let weight: Int?

    var body: some View {
        HStack(spacing: 8) {
            setAndVolumeView
            weightAndCheckmarkView
        }
    }

    private var setAndVolumeView: some View {
        HStack {
            Text(String(set))
                .frame(maxWidth: .infinity, alignment: .leading)
            if let volume {
                Text(String(volume))
                    .foregroundColor(targetVolumeAchieved ? .green : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var weightAndCheckmarkView: some View {
        HStack(spacing: 8) {
            if let weight {
                Text(String(weight))
                    .foregroundColor(targetWeightAchieved ? .green : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 0)
            Image(systemName: Constants.SystemImages.checkmark)
                .frame(width: 40, height: 40)
                .background(Color(targetAchieved ? .Colors.success : .Colors.neutralG30))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var targetAchieved: Bool {
        targetWeight == nil ? targetVolumeAchieved : (targetVolumeAchieved && targetWeightAchieved)
    }
    private var targetVolumeAchieved: Bool {
        volume.map { targetVolume.targetAchieved(value: $0, oneRepMax: oneRepMax) } ?? false
    }
    private var targetWeightAchieved: Bool {
        weight.flatMap { w in targetWeight?.targetAchieved(value: w, oneRepMax: oneRepMax) } ?? false
    }
}
