//
//  SafeSubscript.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
