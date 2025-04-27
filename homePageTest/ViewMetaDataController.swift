//
//  ViewMetaDataController.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

//static class set of int get from AVCapture
import SwiftUI

class ViewMetaDataController: ObservableObject {
    @Published var UPC: String?
    
    init() {
        self.UPC = nil
    }
    
    
}

