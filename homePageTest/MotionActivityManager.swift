//
//  MotionActivityManager.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/25/25.
//

import CoreMotion
import Combine

class MotionActivityManager: ObservableObject {
    private let manager = CMMotionActivityManager()
    
    @Published var activityStatus: String = "Unknown"
    
    
    init() {
        startUpdates()
    }
    var statusWithEmoji: String {
        switch activityStatus {
        case "driving":
            return "🚗"
        case "Stationary":
            return "🛑"
        case "Walking":
            return "🚶 "
        case "Running":
            return "🏃‍♂️ "
        case "Cycling":
            return "🚴‍♂️ "
        default:
            return "❓"
        }
    }
    func startUpdates() {
        manager.startActivityUpdates(to: .main) { activity in
            guard let activity = activity else { return }
            
            if activity.walking {
                
                self.activityStatus = "Walking"
            } else if activity.running {
               
                self.activityStatus = "Running"
            } else if activity.automotive {
             
                self.activityStatus = "driving"
            } else if activity.cycling {
              
                self.activityStatus = "Cycling"
            } else if activity.stationary {
               
                self.activityStatus = "Stationary"
            } else {
                print("Unknown")
            }
        }
    }
}
