import SwiftUI
import CoreLocation
import UIKit

struct SOSAlertView: View {
    @State private var isSending = false
    @State private var showConfirmation = false
    @State private var userLocation: CLLocationCoordinate2D?

    var body: some View {
        VStack(spacing: 20) {
            Text("🚨 Emergency SOS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text("Send a distress alert with your current location to your emergency contacts.")
                .multilineTextAlignment(.center)
                .font(.body)

            Button(action: {
                sendSOS()
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                    Text("Send SOS Alert")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            }

            if isSending {
                ProgressView("Sending SOS...")
            }

            if showConfirmation {
                Text("✅ SOS sent successfully!")
                    .foregroundColor(.green)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            getCurrentLocation()
        }
    }

    func sendSOS() {
        isSending = true
        showConfirmation = false

        // Simulate delay (replace with real SMS/WhatsApp API logic)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isSending = false
            showConfirmation = true
        }

        if let location = userLocation {
            let message = "🚨 SOS! I need help. My current location: https://maps.apple.com/?ll=\(location.latitude),\(location.longitude)"
            print("🆘 Message to send: \(message)")

            // TODO: Integrate with Twilio/WhatsApp API or MFMessageComposeViewController
        }
    }

    func getCurrentLocation() {
        if let loc = CLLocationManager().location?.coordinate {
            self.userLocation = loc
        }
    }
}
