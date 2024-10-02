import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private let baseURL = "https://workout-logger-backend.vercel.app/api"
    
    func addWorkoutLog(workoutPlanItem: WorkoutPlanItem) async throws -> Data {
        guard let url = URL(string: "\(baseURL)/plans/\(workoutPlanItem.id)/add-log") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(workoutPlanItem)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
    func fetchWorkoutLogs(planId: Int) async throws -> [WorkoutPlanItem] {
        guard let url = URL(string: "\(baseURL)/plans/\(planId)/workout-logs") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeWorkoutLogs(from: data)
    }
    
    private func decodeWorkoutLogs(from data: Data) throws -> [WorkoutPlanItem] {
        let decoder = JSONDecoder()
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(isoFormatter)
        
        return try decoder.decode([WorkoutPlanItem].self, from: data)
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
