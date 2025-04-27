//
//  homePageTestApp.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/20/25.
//

import SwiftUI

@main
struct homePageTestApp: App {
  
    @StateObject var VehcicleState = ObservableVehicle()
    @StateObject private var motionManager = MotionActivityManager()
    @StateObject var drivingTracker = DrivingTracker()
    @StateObject var VMD = ViewMetaDataController()

   
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(motionManager)
                .environmentObject(VehcicleState)
               
                .environmentObject(drivingTracker)
                .environmentObject(VMD)
                

        }
    }
}
