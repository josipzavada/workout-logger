//
//  ContentView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            WorkoutModeView()
            WorkoutInputView()
            WorkoutInputView()
            WorkoutInputView()
            Spacer()
        }
        .padding(12)
        .background(Color(.Colors.paper))
    }
}

#Preview {
    ContentView()
}
