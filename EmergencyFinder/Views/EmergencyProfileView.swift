import SwiftUI

struct EmergencyProfileView: View {
    @AppStorage("bloodType") private var bloodType: String = ""
    @AppStorage("allergies") private var allergies: String = ""
    @AppStorage("medications") private var medications: String = ""
    @AppStorage("emergencyContactName") private var emergencyContactName: String = ""
    @AppStorage("emergencyContactPhone") private var emergencyContactPhone: String = ""

    var body: some View {
        Form {
            Section(header: Text("👤 Health Information")) {
                TextField("Blood Group", text: $bloodType)
                TextField("Allergies", text: $allergies)
                TextField("Medications", text: $medications)
            }

            Section(header: Text("📞 Emergency Contact")) {
                TextField("Contact Name", text: $emergencyContactName)
                TextField("Contact Phone", text: $emergencyContactPhone)
                    .keyboardType(.phonePad)
            }

            if !emergencyContactPhone.isEmpty {
                Button(action: callEmergencyContact) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call \(emergencyContactName)")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Emergency Profile")
    }

    func callEmergencyContact() {
        if let url = URL(string: "tel://\(emergencyContactPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
