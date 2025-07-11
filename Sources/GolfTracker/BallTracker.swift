import CoreLocation

/// Responsible for predicting where the ball will land using shot and weather data.
final class BallTracker {
    /// Predicts the landing location of a shot using the carry distance
    /// reported by the GCQuad and a simple wind adjustment.
    ///
    /// The shot is assumed to be hit toward geographic north. The result is a
    /// coordinate offset northward from the input location.
    func predictLanding(
        shot: ShotData,
        from location: CLLocationCoordinate2D,
        wind: WindData
    ) -> CLLocationCoordinate2D {
        // Wind bearing relative to north in radians.
        let windRad = wind.direction * .pi / 180

        // Component of the wind velocity acting along the shot direction
        // (positive is tailwind, negative is headwind).
        let windAlongShot = wind.speed * cos(windRad)

        // Adjust the carry distance based on wind, peak height and spin.
        let spinFactor = max(1.0, shot.backspin / 3000)
        let heightFactor = max(1.0, shot.peakHeight / 30)
        let windAdjustment = windAlongShot * 0.1 * heightFactor / spinFactor
        let adjustedDistance = shot.carryDistance + windAdjustment

        // Convert the northward distance to a change in latitude.
        let earthRadius = 6_378_137.0
        let deltaLat = adjustedDistance / earthRadius * 180 / .pi
        return CLLocationCoordinate2D(
            latitude: location.latitude + deltaLat,
            longitude: location.longitude
        )
    }
}
