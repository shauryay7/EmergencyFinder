import SwiftUI

struct AccidentHelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("🚨 Emergency Accident Instructions")
                    .font(.title2)
                    .bold()

                HelpItem(number: "1", text: "Call emergency services (108 or 911).")
                HelpItem(number: "2", text: "Check breathing. Do CPR if necessary.")
                HelpItem(number: "3", text: "Stop bleeding with clean cloth.")
                HelpItem(number: "4", text: "Don’t move unless needed.")
                HelpItem(number: "5", text: "Keep them warm and calm.")

                Divider()

                Text("🧠 Extra Tips")
                    .font(.headline)

                Text("• No food or water.\n• Turn on side if unconscious.\n• Monitor pulse and breathing.")
            }
            .padding()
        }
        .navigationTitle("Accident Help")
    }
}

struct HelpItem: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .fill(Color.red)
                .frame(width: 24, height: 24)
                .overlay(Text(number).foregroundColor(.white).font(.caption))
            Text(text)
                .font(.body)
        }
    }
}
