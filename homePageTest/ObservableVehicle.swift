//
//  ObservableVehicle.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/25/25.
//

import Foundation
import Combine


class ObservableVehicle: ObservableObject {
    
    
    @Published var selectedVehicle: String = ""
}
