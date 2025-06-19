import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // App header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("EmergencyFinder")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.red)

                        Text("Be prepared. Stay safe.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    // Emergency cards
                    LazyVStack(spacing: 20) {
                        EmergencyCard(
                            title: "🚑 Find Nearby Hospitals",
                            subtitle: "Locate emergency hospitals around you",
                            gradient: Gradient(colors: [Color.red, Color.orange]),
                            destination: HospitalsView()
                        )

                        EmergencyCard(
                            title: "🩹 Accident Help",
                            subtitle: "What to do in emergency situations",
                            gradient: Gradient(colors: [Color.orange, Color.yellow]),
                            destination: AccidentHelpView()
                        )

                        EmergencyCard(
                            title: "💊 Medicine Suggestions",
                            subtitle: "Get first-aid medicines by condition",
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            destination: MedicinesView()
                        )

                        EmergencyCard(
                            title: "🆘 SOS Alert",
                            subtitle: "Send instant help message with location",
                            gradient: Gradient(colors: [Color.pink, Color.red]),
                            destination: SOSAlertView()
                        )
                        
                        EmergencyCard(
                            title: "🧑‍⚕️ Find Doctor by Specialty",
                            subtitle: "Search Cardiologists, Pediatricians, and more",
                            gradient: Gradient(colors: [Color.purple, Color.indigo]),
                            destination: DoctorFinderView()
                        )

                        EmergencyCard(
                            title: "🩺 Emergency Profile",
                            subtitle: "Store and share health/contact info",
                            gradient: Gradient(colors: [Color.mint, Color.teal]),
                            destination: EmergencyProfileView()
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
        }
    }
}

struct EmergencyCard<Destination: View>: View {
    var title: String
    var subtitle: String
    var gradient: Gradient
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack(alignment: .leading) {
                LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
            .frame(height: 110)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
