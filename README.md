# Workout Tracker iOS App

This is an iOS app designed for tracking workout plans and logging progress. The app fetches the workout plan from a backend and allows the user to track their progress for each workout in the plan. Additionally, users can view previous logs, filtering them by date and time.

The backend is deployed on Vercel, so no local setup is needed for the backend.

## Requirements

- Xcode 16
- iOS 18.0+

## Features

- **Workout Plan Fetching**: The app fetches workout plans from a remote backend.
- **Progress Tracking**: Users can log their performance for each workout in the plan.
- **Log History**: Previous workout logs can be viewed by date and time.
- **Dynamic Placeholders**: Placeholders auto-populate based on the user's 1RM (One Rep Max) and target weights for weight-based workouts.
- **Flexible Design**: The codebase is designed to be easily extendable for various workout modes (e.g., EMOM, supersets, pyramid sets, max tests, AMRAPs, etc.).

## Backend

- The backend for this app is hosted on Vercel: [Workout Logger Backend](https://workout-logger-backend.vercel.app)
- You can also check the backend repository here: [Backend GitHub Repository](https://github.com/josipzavada/workout-logger-backend)

There is no need to set up or run the backend locally—just run the iOS app, and it will communicate with the backend automatically.

## Notes regarding the spec

### 1. Auto-populating Cells with Data

The specification mentions that cells should auto-populate with data from the workout instructions. This feature is implemented only for workouts with weight targets based on the user's 1RM. Once a 1RM value is entered, placeholders adjust to display the correct targets.

For other workouts, the placeholders display the target values as defined in the backend. It's assumed that these targets are defined by a trainer in the admin app.

### 2. Inheriting Values in Cells

While the specification requests that once a user tracks a value in a cell, subsequent cells should inherit that value, this behavior was not implemented. Instead, placeholders displaying the target weight or reps were used to avoid the need for users to delete pre-filled values if they exceed or miss their targets, ensuring a smoother user experience.

### 3. Flexible Workout Modes

The app is designed with flexibility in mind, and the workout modes are implemented in the app's structure. The codebase is ready to support additional modes other than the ones provided.

## Contact

If you encounter any issues while running the app or have questions, feel free to reach out!
