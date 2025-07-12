import CoreLocation

@MainActor
/// Provides the current GPS location using CoreLocation.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D?, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func currentLocation() async -> CLLocationCoordinate2D? {
        // Check current authorization status
        let authStatus = manager.authorizationStatus
        
        switch authStatus {
        case .notDetermined:
            print("Location authorization not determined, requesting access...")
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location access denied or restricted")
            return nil
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            print("Unknown location authorization status")
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            if let location = locations.first {
                print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.continuation?.resume(returning: location.coordinate)
            } else {
                print("No location data received")
                self.continuation?.resume(returning: nil)
            }
            self.continuation = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            print("Location manager failed with error: \(error.localizedDescription)")
            self.continuation?.resume(returning: nil)
            self.continuation = nil
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            switch status {
            case .notDetermined:
                print("Location authorization: Not determined")
            case .denied:
                print("Location authorization: Denied")
                self.continuation?.resume(returning: nil)
                self.continuation = nil
            case .restricted:
                print("Location authorization: Restricted")
                self.continuation?.resume(returning: nil)
                self.continuation = nil
            case .authorizedWhenInUse:
                print("Location authorization: Authorized when in use")
            case .authorizedAlways:
                print("Location authorization: Always authorized")
            @unknown default:
                print("Location authorization: Unknown status")
                self.continuation?.resume(returning: nil)
                self.continuation = nil
            }
        }
    }
}
