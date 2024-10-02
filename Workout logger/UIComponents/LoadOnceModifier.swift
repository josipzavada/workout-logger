//
//  LoadOnceModifier.swift
//  Workout logger
//
//  Created by Josip Zavada on 02.10.2024..
//

import SwiftUI

struct LoadOnceModifier: ViewModifier {
    @State private var hasLoaded = false
    let action: () async -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasLoaded {
                    Task {
                        await action()
                        hasLoaded = true
                    }
                }
            }
    }
}

extension View {
    func loadOnce(perform action: @escaping () async -> Void) -> some View {
        self.modifier(LoadOnceModifier(action: action))
    }
}
