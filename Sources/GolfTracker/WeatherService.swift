import Foundation
import CoreLocation

struct WindData {
    let speed: Double // meters per second
    let direction: Double // degrees from north
}

/// Retrieves weather information to account for wind effect on the ball.
final class WeatherService {
    func currentWind(at location: CLLocationCoordinate2D) async -> WindData {
        // TODO: Replace with real weather API (e.g. WeatherKit or OpenWeather).
        // For now return a dummy calm wind.
        return WindData(speed: 0, direction: 0)
    }
}
