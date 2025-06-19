import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), // default: Delhi
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @Published var hospitals: [Hospital] = []

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func searchDoctors(specialty: String) {
        guard let location = manager.location else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = specialty
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            if let items = response?.mapItems {
                self.hospitals = items.map {
                    Hospital(
                        name: $0.name ?? "\(specialty)",
                        coordinate: $0.placemark.coordinate,
                        distance: location.distance(from: $0.placemark.location ?? location)
                    )
                }
            }
        }
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("❌ No location available")
            return
        }

        print("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )

        fetchNearbyHospitals(location: location)
    }

    func fetchNearbyHospitals(location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hospital"
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("❌ MKLocalSearch error: \(error.localizedDescription)")
                return
            }

            guard let items = response?.mapItems, !items.isEmpty else {
                print("⚠️ No hospitals found. Using fallback.")
                self.hospitals = [
                    Hospital(name: "Fallback Hospital", coordinate: location.coordinate, distance: 0)
                ]
                return
            }

            print("✅ Found \(items.count) hospitals")

            self.hospitals = items.compactMap { item in
                guard let name = item.name else { return nil }
                let coord = item.placemark.coordinate
                let dist = location.distance(from: CLLocation(latitude: coord.latitude, longitude: coord.longitude))
                return Hospital(name: name, coordinate: coord, distance: dist)
            }.sorted(by: { $0.distance < $1.distance })
        }
    }
}

struct Hospital: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: CLLocationDistance
}
