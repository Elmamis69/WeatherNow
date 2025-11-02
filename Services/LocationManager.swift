import CoreLocation

enum LocationError: Error { case denied, unknown }

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var cont: CheckedContinuation<CLLocationCoordinate2D, Error>?

    func requestLocation() async throws -> CLLocationCoordinate2D {
        manager.delegate = self
        switch manager.authorizationStatus {
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .denied, .restricted: throw LocationError.denied
        default: break
        }
        manager.requestLocation()
        return try await withCheckedThrowingContinuation { cont in
            self.cont = cont
        }
    }

    func locationManager(_ m: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        if let c = locs.first?.coordinate { cont?.resume(returning: c); cont = nil }
    }
    func locationManager(_ m: CLLocationManager, didFailWithError error: Error) {
        cont?.resume(throwing: error); cont = nil
    }
    func locationManagerDidChangeAuthorization(_ m: CLLocationManager) {
        if m.authorizationStatus == .denied { cont?.resume(throwing: LocationError.denied); cont = nil }
    }
}
