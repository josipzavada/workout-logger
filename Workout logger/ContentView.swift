//
//  ContentView.swift
//  Workout logger
//
//  Created by Josip Zavada on 26.09.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    WorkoutModeView()
                    WorkoutMaxInputView()
                    WorkoutInputView()
                    Spacer()
                }
                .padding(12)
                .background(Color(.Colors.paper))
                .clipShape(.rect(cornerRadius: 16))
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
