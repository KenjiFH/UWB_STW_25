//
//  StatsView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var drivingTracker: DrivingTracker
    @EnvironmentObject var carState: ObservableVehicle
    
    func deleteTrip(at offsets: IndexSet) {
        drivingTracker.trips.remove(atOffsets: offsets)
    }
    
    func addTrip() {
        drivingTracker.add_trip()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                VStack(spacing: 16) {
                    NavigationLink(destination: FoodResultsView()) {
                        Text("View Food Summary")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: DrivingSummaryView()) {
                        Text("View Driving Summary")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: FoodStatsView()) {
                        Text("View Food")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                List {
                    ForEach(drivingTracker.trips) { trip in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Date: \(trip.date.formatted(date: .abbreviated, time: .shortened))")
                                .font(.headline)
                            Text("Distance: \(String(format: "%.2f", trip.distance)) miles")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: deleteTrip)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Your Impact")
            }
        }
    }
}

