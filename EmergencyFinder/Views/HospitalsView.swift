import SwiftUI
import MapKit

struct HospitalsView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            Map(initialPosition: .region(locationManager.region)) {
                ForEach(locationManager.hospitals) { hospital in
                    Annotation(hospital.name, coordinate: hospital.coordinate) {
                        VStack {
                            Text("🏥")
                            Text(hospital.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(6)
                        }
                    }
                }
                UserAnnotation()
            }
            .frame(height: 300)
            .cornerRadius(12)
            .padding(.horizontal)

            if locationManager.hospitals.isEmpty {
                ProgressView("Searching nearby hospitals...")
                    .padding()
            } else {
                List(locationManager.hospitals) { hospital in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(hospital.name)
                            .font(.headline)
                        Text(String(format: "%.2f km away", hospital.distance / 1000))
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button(action: {
                            openInMaps(hospital: hospital)
                        }) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Navigate")
                            }
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Nearby Hospitals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("🔁 Refresh button tapped")
                    locationManager.requestLocation()
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.blue)
                }
                .accessibilityLabel("Refresh Hospital List")
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    private func openInMaps(hospital: Hospital) {
        let placemark = MKPlacemark(coordinate: hospital.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = hospital.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
