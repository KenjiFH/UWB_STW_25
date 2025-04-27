//
//  TravelView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import SwiftUI

struct TravelView: View {

    @EnvironmentObject var vehicleState: ObservableVehicle
    @EnvironmentObject var motionManager: MotionActivityManager
    @EnvironmentObject var drivingTracker: DrivingTracker

    @State private var animate = false
    let userDefaults = UserDefaults.standard

    var body: some View {
        NavigationView {
            VStack {

                VStack {
                    Text(motionManager.statusWithEmoji)
                        .font(.system(size: 60))
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: animate)
                        .onChange(of: motionManager.activityStatus) { _ in
                            animate = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animate = false
                            }
                        }
                    Text("Current Activity")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "car.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                        Text("Selected Vehicle:")
                            .font(.headline)
                        Spacer()
                        Text(userDefaults.string(forKey: "selectedVehicle") ?? "Unknown")
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.title3)
                            .foregroundColor(.green)
                        Text("Detected Activity:")
                            .font(.headline)
                        Spacer()
                        Text(motionManager.activityStatus)
                            .font(.title2)
                            .foregroundColor(.green)
                            .onChange(of: motionManager.activityStatus) { newState in
                                drivingTracker.updateDrivingStatus(from: newState)
                            }
                    }

                    Divider()

                    HStack {
                        Image(systemName: "road.lanes")
                            .font(.title3)
                            .foregroundColor(.orange)
                        Text("Total Miles Driven:")
                            .font(.headline)
                        Spacer()
                        Text("\(String(format: "%.2f", drivingTracker.milesDriven)) miles")
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Image(systemName: "location.north.fill")
                            .font(.title3)
                            .foregroundColor(.purple)
                        Text("Current Trip Distance:")
                            .font(.headline)
                        Spacer()
                        Text("\(String(format: "%.2f", drivingTracker.currentTripDist)) miles")
                            .foregroundColor(.primary)
                    }
                }
                .padding(30)
                .background(Color(.systemGray6))
                .cornerRadius(15)

                Spacer()
            }
            .padding()
            .navigationTitle("Travel Insights")
        }
    }
}

#Preview {
    TravelView()
        .environmentObject(ObservableVehicle())
        .environmentObject(MotionActivityManager())
        .environmentObject(DrivingTracker())
}
