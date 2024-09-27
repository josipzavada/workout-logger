//
//  WorkoutLogView.swift
//  Workout logger
//
//  Created by Josip Zavada on 27.09.2024..
//

import SwiftUI

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
                    WorkoutInputView()
                    WorkoutInputView()
                    WorkoutInputView()
                    Spacer()
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
