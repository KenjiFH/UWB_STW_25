//
//  SettingsView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import SwiftUI
import CoreData

enum VehicleType: String, CaseIterable, Identifiable {
    case bus = "Bus"
    case smallCar = "Small Car"
    case sedan = "Sedan"
    case suv = "SUV"
    case pickup = "Pickup Truck"
    case hybrid = "Hybrid/Electric"

    var id: String { self.rawValue }
}

func calculateEMF(vhc: String) -> Double {
    switch vhc {
    case "Sedan": return 0.28
    case "SUV": return 0.41
    case "Pickup Truck": return 0.46
    case "Hybrid/Electric": return 0.15
    case "Bus": return 0.089
    case "Small Car": return 0.28
    default:
        
        return 0.0
    }
}

func returnColor(emf: Double) -> Color {
    switch emf {
    case 0..<0.27: return .green
    case 0.28: return .yellow
    default: return .red
    }
}

func returnStatus(emf: Double) -> String {
    switch emf {
    case 0.28: return "MEDIUM"
    case 0.41, 0.46: return "HIGH"
    case 0.15: return "LOW"
    case 0.089: return "VERY LOW"
    default:
        
        return ""
    }
}

struct SettingsView: View {

    @EnvironmentObject var vehicleState: ObservableVehicle
    @State var selectedVehicle: VehicleType = .sedan
    let userDefaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle Selection").font(.headline)) {
                    Picker("Select your vehicle", selection: $selectedVehicle) {
                        ForEach(VehicleType.allCases) { vehicle in
                            Text(vehicle.rawValue).tag(vehicle)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedVehicle) { newValue in
                        userDefaults.setValue(newValue.rawValue, forKey: "selectedVehicle")
                        vehicleState.selectedVehicle = userDefaults.string(forKey: "selectedVehicle") ?? "Unknown"
                    }
                }

                Section(header: Text("Emission Factor Information").font(.headline)) {
                    let currentEMF = calculateEMF(vhc: selectedVehicle.rawValue)
                    let emfColor = returnColor(emf: currentEMF)
                    let impactText = returnStatus(emf: currentEMF)

                    HStack {
                        Text("Selected Vehicle:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(selectedVehicle.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Text("Estimated EMF:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(currentEMF, specifier: "%.2f") kg CO₂/mile")
                            .font(.subheadline)
                            .foregroundColor(emfColor)
                    }

                    HStack {
                        Text("Emission Impact:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(impactText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(emfColor)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Understanding EMF")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Group {
                            switch selectedVehicle.rawValue {
                            case "Sedan":
                                Text("Sedans typically have a moderate emission factor, balancing passenger capacity and fuel efficiency.")
                            case "SUV":
                                Text("SUVs generally have a higher emission factor due to their larger size and often lower fuel economy compared to smaller cars.")
                            case "Pickup Truck":
                                Text("Pickup trucks tend to have the highest emission factors among personal vehicles due to their size, weight, and power.")
                            case "Hybrid/Electric":
                                Text("Hybrid and electric vehicles have significantly lower emission factors, especially when considering electricity from renewable sources. The factor shown here accounts for some emissions from electricity generation or hybrid engine use.")
                            case "Bus":
                                Text("Buses have a relatively low emission factor per mile *per passenger* due to their high carrying capacity, making them a more efficient option for transporting many people.")
                            case "Small Car":
                                Text("Small cars generally have a lower emission factor due to their lighter weight and better fuel efficiency compared to larger vehicles.")
                            default:
                                Text("Emission factor details for this vehicle category are not available.")
                            }
                        }
                        .font(.caption2)
                        .foregroundColor(.gray)

                        Text("These factors are estimates and can vary based on the specific vehicle model, driving conditions, and maintenance.")
                            .font(.caption2)
                            .foregroundColor(Color.gray.opacity(0.7))
                    }
                    .padding(.top, 5)
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            if let savedVehicle = userDefaults.string(forKey: "selectedVehicle"),
               let vehicle = VehicleType(rawValue: savedVehicle) {
                selectedVehicle = vehicle
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ObservableVehicle())
}
