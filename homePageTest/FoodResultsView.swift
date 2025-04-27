//
//  FoodResultsView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/27/25.
//


import SwiftUI

struct FoodResultsView: View {
    @State private var totalCarbonScore = UserDefaults.standard.double(forKey: carbonScoreKey)

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                relatableStatsView
                howToReduceImpactView
                Spacer()
            }
            .padding()
            .navigationTitle("Your Food Impact")
            .onAppear(perform: loadTotalCarbonScore)
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(alignment: .leading) {
            Text("Total Estimated Food Carbon Impact")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(String(format: "%.2f kg CO₂e", totalCarbonScore))
                .font(.largeTitle.bold())
                .foregroundColor(.orange)
        }
    }

    private var relatableStatsView: some View {
        Group {
            if totalCarbonScore > 0 {
                Text("This is roughly equivalent to:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text(relatableDrivingStat(carbonScore: totalCarbonScore))
                    Text(relatableElectricityStat(carbonScore: totalCarbonScore))
                    Text(relatableBeefStat(carbonScore: totalCarbonScore))
                }
                .padding(.leading)
            } else {
                Text("No food impact data recorded yet.")
                    .foregroundColor(.gray)
                    .italic()
            }
        }
    }

    private var howToReduceImpactView: some View {
        VStack(alignment: .leading) {
            Text("Tips to Reduce Your Food Carbon Footprint:")
                .font(.headline)
                .padding(.top)

            List {
                Text("Eat more plant-based meals.")
                Text("Buy local and seasonal produce.")
                Text("Reduce food waste by planning and storing properly.")
                Text("Choose products with less packaging.")
                Text("Consider the carbon footprint of imported foods.")
                Text("Opt for sustainably sourced seafood.")
            }
            .listStyle(.automatic)
        }
    }

    // MARK: - Functions

    func loadTotalCarbonScore() {
        totalCarbonScore = getTotalCarbonScore()
    }

    func getTotalCarbonScore() -> Double {
        return UserDefaults.standard.double(forKey: carbonScoreKey)
    }

    // MARK: - Helper Functions for Relatable Stats

    func relatableDrivingStat(carbonScore: Double) -> String {
        let kmDriven = carbonScore / 0.246 // Average car emissions per km (adjust based on region)
        return String(format: "Driving approximately %.1f km in an average car.", kmDriven)
    }

    func relatableElectricityStat(carbonScore: Double) -> String {
        let kwhUsed = carbonScore / 0.00041 // Average CO2e per kWh of electricity (adjust based on region)
        return String(format: "Using about %.0f kWh of electricity.", kwhUsed)
    }

    func relatableBeefStat(carbonScore: Double) -> String {
        let beefEquivalent = carbonScore / 13.0 // Average kg CO2e per kg of beef
        return String(format: "Consuming roughly %.2f kg of beef.", beefEquivalent)
    }
}

// Constants.swift (Ensure this file exists with the key)
import Foundation

let carbonScoreKey = "totalCarbonImpactScore"
