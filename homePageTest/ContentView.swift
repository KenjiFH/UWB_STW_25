//
//  ContentView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/20/25.
//

/*
 VehicleDetails(selectedVehicle: $selectedVehicle)
          
          Text("You selected: \(selectedVehicle.rawValue)")
              .padding()
 */

import SwiftUI

import CoreData
struct ContentView: View {
            
    let tips = [
        "Enjoy the benefits of walking, biking, or using public transport for a healthier commute and planet!",
        "Connect with friends and reduce your carbon footprint by carpooling!",
        "Explore delicious plant-based meals and discover the variety of sustainable food choices!",
        "Savor the freshness and support your community by choosing locally sourced, seasonal foods!",
        "Become a waste-reduction champion through recycling and composting!",
        "Value our precious water resources by taking refreshing, shorter showers and fixing any leaks!",
        "Save energy effortlessly by unplugging electronics when they're not in use!",
        "Empower businesses that prioritize a sustainable future with your support!",
        "Contribute to a greener world by planting trees and helping to clean our air!",
        "remember, everyone can be a superhero and SAVE THE WORLD!",
    ];

    
    var body: some View {
        //@AppStorage("vehicleType") var vehicleType: String = "Unknown"
       // Text("Selected Vehicle: \(vehicleType)")

        
        NavigationStack {
            
            Text("GreenLog")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("What Can you Do?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                            .padding( 5)
                        Text(tip)
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            
            Spacer()
            HStack(spacing: 5) {
                
                
                NavigationLink(destination: BarcodeScannerView()) {
                    Label("Scan", systemImage: "camera.circle.fill")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 100, height: 50)
                        .frame(minWidth: 50, maxWidth: 200)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    
                    
                }
                
                NavigationLink(destination: TravelView()) {
                    VStack(spacing : 20){
                        
                        Label("Travel", systemImage: "car.side.rear.open.fill")
                        
                        
                        
                        
                    }  .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 100, height: 50)
                        .frame(minWidth: 50, maxWidth: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
                
                NavigationLink(destination: SettingsView()) {
                    HStack(spacing : 5){
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                        
                    } .frame(width: 100, height: 50)
                        .frame(minWidth: 50, maxWidth: 200)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    
                }
            }
            .padding(5)
          
                NavigationLink(destination: StatsView()) {
                    HStack(spacing : 5){
                        Image(systemName: "globe.americas.fill")
                        Text("Impact")
                        
                    }
                    
                    
                } .frame(width: 100, height: 50)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(minWidth: 50, maxWidth: 100)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
      
                
            
        }
    }
    
}

#Preview {
    ContentView()
}
