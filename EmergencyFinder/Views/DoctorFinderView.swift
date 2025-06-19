import SwiftUI
import MapKit

struct DoctorFinderView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedSpecialty = "Cardiologist"
    let specialties = ["Cardiologist", "Pediatrician", "Dentist", "Orthopedic", "Neurologist", "General Physician"]

    var body: some View {
        VStack(spacing: 16) {
            // Header Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Doctor Finder")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                Text("Select a specialty to find doctors near you")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .padding(.top)

            // Specialty Dropdown
            VStack(alignment: .leading, spacing: 6) {
                Text("Specialty")
                    .font(.headline)
                    .padding(.horizontal)

                Picker("Select Specialty", selection: $selectedSpecialty) {
                    ForEach(specialties, id: \.self) { specialty in
                        Text(specialty)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }

            // Map Section
            Map(initialPosition: .region(locationManager.region)) {
                ForEach(locationManager.hospitals) { doctor in
                    Annotation(doctor.name, coordinate: doctor.coordinate) {
                        VStack(spacing: 2) {
                            Image(systemName: "cross.case.fill")
                                .foregroundColor(.red)
                            Text(doctor.name)
                                .font(.caption2)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(5)
                        }
                    }
                }
                UserAnnotation()
            }
            .frame(height: 260)
            .cornerRadius(12)
            .padding(.horizontal)

            // Doctor List Section
            if locationManager.hospitals.isEmpty {
                Spacer()
                ProgressView("Searching for nearby \(selectedSpecialty)s...")
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(locationManager.hospitals) { doctor in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(doctor.name)
                                .font(.headline)

                            Text(String(format: "%.2f km away", doctor.distance / 1000))
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button(action: {
                                openInMaps(doctor: doctor)
                            }) {
                                Label("Navigate", systemImage: "location.fill")
                                    .font(.subheadline)
                                    .padding(6)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }

            Spacer()
        }
        .navigationTitle("Find a Doctor")
        .onAppear {
            locationManager.requestLocation()
            locationManager.searchDoctors(specialty: selectedSpecialty)
        }
        .onChange(of: selectedSpecialty) { newSpecialty in
            locationManager.searchDoctors(specialty: newSpecialty)
        }
    }

    private func openInMaps(doctor: Hospital) {
        let placemark = MKPlacemark(coordinate: doctor.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = doctor.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
