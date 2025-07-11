import CoreLocation

/// Responsible for predicting where the ball will land using shot and weather data.
final class BallTracker {
    func predictLanding(shot: ShotData, from location: CLLocationCoordinate2D, wind: WindData) -> CLLocationCoordinate2D {
        // TODO: Replace with sophisticated physics model.
        // This stub simply advances the latitude by a rough distance calculation.
        let distanceMeters = shot.ballSpeed * cos(shot.launchAngle * .pi/180) * 0.5
        let earthRadius = 6378137.0
        let deltaLat = distanceMeters / earthRadius * 180 / .pi
        return CLLocationCoordinate2D(latitude: location.latitude + deltaLat, longitude: location.longitude)
    }
}
