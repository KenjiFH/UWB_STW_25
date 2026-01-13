//
//  DrivingTracker.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import CoreLocation
import SwiftUI


class DrivingTracker: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    
    
    private var manager = CLLocationManager()
    private var lastLocation: CLLocation?
    @Published var milesDriven: Double = 0.0
    @Published var isDriving: Bool = false
   
    @Published var currentTripDist: Double = 0.0
    
    var TripEnded = false
    
    
    @State private var animate = false
    
    
    
    struct Trip: Codable, Identifiable {
        var id = UUID()
        let date: Date
     
        let distance: Double
    }
    
    @Published var trips: [Trip] = [] {
         didSet {
             saveTrips()
         }
     }

    
   
    

   

    override init() {
        
        super.init()
        loadTrips()
        milesDriven = UserDefaults.standard.double(forKey: "milesDriven")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "savedTrips")
        }
    }

    func loadTrips() {
        if let savedTrips = UserDefaults.standard.data(forKey: "savedTrips") {
            if let decoded = try? JSONDecoder().decode([Trip].self, from: savedTrips) {
                trips = decoded
            }
        }
    }
    func updateDrivingStatus(from state: String) {
         if state == "driving" {
             isDriving = true
         } else {
             isDriving = false
             //log event
             //get current vhc
             if(currentTripDist == 0){
                 return
             } else {
                 let newTrip = Trip(date: Date(),distance: currentTripDist)
                 trips.append(newTrip)
             }
            
            
             
             currentTripDist = 0;
         }
     }
    
    
    func add_trip(){
        let newTrip = Trip(date: Date(),distance: 0)
        trips.append(newTrip)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
       
        guard let newLocation = locations.last else { return }
        guard isDriving else { return }

        if let last = lastLocation {
            let distanceInMeters = newLocation.distance(from: last)
            let distanceInMiles = distanceInMeters / 1609.34
            milesDriven += distanceInMiles
            currentTripDist += distanceInMiles
            UserDefaults.standard.set(milesDriven, forKey: "milesDriven")
        }

        lastLocation = newLocation
    }
}


