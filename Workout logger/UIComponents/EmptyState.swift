//
//  EmptyState.swift
//  Workout logger
//
//  Created by Josip Zavada on 02.10.2024..
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Constants.SystemImages.tray)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)

            Text(message)
                .foregroundColor(.gray)
        }
        .padding(36)
        .multilineTextAlignment(.center)
    }
}
