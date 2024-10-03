//
//  DottedLine.swift
//  Workout logger
//
//  Created by Josip Zavada on 02.10.2024..
//

import SwiftUI

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
