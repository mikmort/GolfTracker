import SwiftUI

@MainActor
struct ContentView: View {
    @State private var result = ""
    private let gcQuad = GCQuadManager()
    private let locationManager = LocationManager()
    private let weather = WeatherService()
    private let tracker = BallTracker()
    private let videoRecorder = VideoRecorder()

    var body: some View {
        Text(result.isEmpty ? "Running..." : result)
            .padding()
            .task {
                await videoRecorder.startRecording()
                guard let shotLocation = await locationManager.currentLocation() else {
                    result = "Failed to get location"
                    return
                }
                guard let shotData = await gcQuad.readShotData() else {
                    result = "No shot data available"
                    return
                }
                let wind = await weather.currentWind(at: shotLocation)
                let predicted = tracker.predictLanding(shot: shotData, from: shotLocation, wind: wind)
                await videoRecorder.stopRecording()
                result = "Predicted landing at \(predicted.latitude), \(predicted.longitude)"
            }
    }
}

#Preview {
    ContentView()
}
