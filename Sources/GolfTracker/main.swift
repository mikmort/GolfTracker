import Foundation
import CoreLocation

@main
struct GolfTrackerApp {
    static func main() async {
        let gcQuad = GCQuadManager()
        let locationManager = LocationManager()
        let weather = WeatherService()
        let tracker = BallTracker()
        let videoRecorder = VideoRecorder()

        await videoRecorder.startRecording()
        guard let shotLocation = await locationManager.currentLocation() else {
            print("Failed to get location")
            return
        }

        guard let shotData = await gcQuad.readShotData() else {
            print("No shot data available")
            return
        }

        let wind = await weather.currentWind(at: shotLocation)
        let predicted = tracker.predictLanding(shot: shotData, from: shotLocation, wind: wind)
        print("Predicted landing at \(predicted.latitude), \(predicted.longitude)")

        await videoRecorder.stopRecording()
    }
}
