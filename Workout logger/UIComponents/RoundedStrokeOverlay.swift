//
//  RoundedStrokeOverlay.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

import SwiftUI

struct RoundedStrokeOverlay: ViewModifier {
    let cornerRadius: CGFloat
    let strokeColor: Color
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func roundedStrokeOverlay(
        cornerRadius: CGFloat = 16,
        strokeColor: Color = .init(.Colors.paperDark),
        lineWidth: CGFloat = 1
    ) -> some View {
        self.modifier(
            RoundedStrokeOverlay(
                cornerRadius: cornerRadius,
                strokeColor: strokeColor,
                lineWidth: lineWidth
            )
        )
    }
}
