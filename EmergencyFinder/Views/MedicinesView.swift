import SwiftUI

struct MedicinesView: View {
    var body: some View {
        List {
            Section(header: Text("💊 Emergency Medicines").font(.headline)) {
                MedicineCard(name: "Paracetamol", use: "Fever and mild pain relief")
                MedicineCard(name: "Ibuprofen", use: "Anti-inflammatory & pain relief")
                MedicineCard(name: "Antiseptic Cream", use: "Prevents infection in cuts")
                MedicineCard(name: "ORS", use: "Rehydration during dehydration")
                MedicineCard(name: "Betadine", use: "For wound cleaning")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Medicine Suggestions")
    }
}

struct MedicineCard: View {
    let name: String
    let use: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name)
                .font(.headline)
            Text(use)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}
