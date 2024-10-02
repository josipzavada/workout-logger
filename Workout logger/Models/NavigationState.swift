//
//  NavigationStatel.swift
//  Workout logger
//
//  Created by Josip Zavada on 30.09.2024..
//

import SwiftUI

enum NavigationState: Hashable {
    case workoutLogsView(workoutPlanItem: WorkoutPlanItem)
    case singleWorkoutLogView(workoutPlanItem: WorkoutPlanItem)
    case newWorkoutLogView(workoutPlanItem: WorkoutPlanItem)
}

class NavigationPathModel: ObservableObject {
    @Published var path = [NavigationState]()
}
