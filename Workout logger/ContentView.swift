//
//  ContentView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            WorkoutModeView()
            WorkoutInputView()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
