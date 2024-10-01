//
//  NavigationStatel.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

enum NavigationState: Hashable {
    case workoutLogsView(planId: Int)
    case singleWorkoutLogView
    case newWorkoutLogView
}
