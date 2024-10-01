//
//  NavigationStatel.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

enum NavigationState: Hashable {
    case workoutLogsView(workoutPlanItem: WorkoutPlanItem)
    case singleWorkoutLogView(workoutPlanItem: WorkoutPlanItem)
    case newWorkoutLogView(workoutPlanItem: WorkoutPlanItem)
}
