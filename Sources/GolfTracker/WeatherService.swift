import Foundation
import CoreLocation

struct WindData {
    let speed: Double // meters per second
    let direction: Double // degrees from north
}

/// Retrieves weather information to account for wind effect on the ball.
final class WeatherService {
    /// Fetches wind data from the Open-Meteo public API.
    /// Falls back to calm conditions on failure.
    func currentWind(at location: CLLocationCoordinate2D) async -> WindData {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&current_weather=true"
        guard let url = URL(string: urlString) else {
            return WindData(speed: 0, direction: 0)
        }

        struct APIResponse: Decodable {
            struct CurrentWeather: Decodable {
                let windspeed: Double?
                let winddirection: Double?
            }
            let currentWeather: CurrentWeather

            private enum CodingKeys: String, CodingKey {
                case currentWeather = "current_weather"
            }
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            if let speed = response.currentWeather.windspeed,
               let direction = response.currentWeather.winddirection {
                // Open-Meteo returns speed in m/s and direction in degrees.
                return WindData(speed: speed, direction: direction)
            }
        } catch {
            print("Weather fetch failed: \(error)")
        }
        return WindData(speed: 0, direction: 0)
    }
}
