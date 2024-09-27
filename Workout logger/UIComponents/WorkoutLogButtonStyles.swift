//
//  WorkoutLogButton.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

struct WorkoutLogButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 16))
            .padding(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct PlainWorkoutLogButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
