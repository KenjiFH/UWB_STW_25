//
//  DrivingSummaryView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import SwiftUI
import Charts

struct DrivingSummaryView: View {
    @EnvironmentObject var drivingTracker: DrivingTracker

    // Conversion factor: approximate kg of CO2 emitted per mile for an average gasoline car
    let co2PerMile: Double = 0.404 // Source: EPA estimates

    // Chart data: all trips with their distances and dates
    var chartData: [ChartData] {
        return drivingTracker.trips.map { ChartData(distance: $0.distance, date: $0.date) }
    }

    var totalEmissions: Double {
        drivingTracker.milesDriven * co2PerMile
    }

    var averageTripDistance: Double {
        let totalTrips = drivingTracker.trips.count
        let sumOfDistances = drivingTracker.trips.reduce(0) { $0 + $1.distance }
        return totalTrips > 0 ? sumOfDistances / Double(totalTrips) : 0
    }

    var longestTripDistance: Double {
        drivingTracker.trips.max(by: { $0.distance < $1.distance })?.distance ?? 0
    }

    // MARK: - Emission Comparisons (Relatable Examples)

    var treesToOffset: Int {
        // Approximate CO2 absorption per tree per year (can vary greatly)
        let co2PerTreePerYear: Double = 22 // kg CO2/year
        return Int(ceil(totalEmissions / co2PerTreePerYear))
    }

    var lightBulbsEquivalent: Int {
        // Approximate CO2 emission per kWh of electricity generation (US average)
        let co2PerKWh: Double = 0.39 // kg CO2/kWh
        // Assuming an average incandescent bulb uses 0.06 kWh per hour
        let kwhForTotalEmissions = totalEmissions / co2PerKWh
        // Assuming an average light bulb is on for 1000 hours per year
        let kwhPerBulbYear = 0.06 * 1000
        return Int(ceil(kwhForTotalEmissions / kwhPerBulbYear))
    }

    var beefEquivalent: Double {
        // Approximate kg of CO2 equivalent emissions per kg of beef
        let co2PerKgBeef: Double = 27 // kg CO2e/kg
        // Assuming average beef consumption of 0.2 kg per meal
        return totalEmissions / co2PerKgBeef
    }

    // MARK: - Actionable Tips

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🚗 Driving Summary")
                    .font(.largeTitle)
                    .bold()

                Text("You've driven a total of \(drivingTracker.milesDriven, specifier: "%.2f") miles.")
                Text("Your estimated total emissions are \(totalEmissions, specifier: "%.2f") kg of CO₂.")

                VStack(alignment: .leading, spacing: 10) {
                    Text("What does this mean?")
                        .font(.headline)
                    Text("Your emissions are roughly equivalent to:")
                    Text("🌳 The amount of CO₂ that about \(treesToOffset) mature trees can absorb in a year.")
                    Text("💡 The emissions from leaving approximately \(lightBulbsEquivalent) incandescent light bulbs on for a year.")
                    Text("🥩 The emissions equivalent to consuming about \(beefEquivalent, specifier: "%.1f") kg of beef.")
                }
                .padding(.vertical)

                Text("Average trip distance: \(averageTripDistance, specifier: "%.2f") miles")
                Text("Longest trip distance: \(longestTripDistance, specifier: "%.2f") miles")

              

                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 What you can do:")
                        .font(.headline)
                    Text("Consider taking shorter trips when possible.")
                    Text("Explore alternative transportation like walking, biking, or public transit for shorter distances.")
                    Text("If you need to drive, try to combine errands into a single trip.")
                    Text("Ensure your vehicle is well-maintained, including proper tire inflation, for better fuel efficiency.")
                    Text("When it's time for a new car, consider electric or hybrid vehicles.")
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
}

// Chart data model for easy access to trip distance and date
struct ChartData {
    var distance: Double
    var date: Date
}
