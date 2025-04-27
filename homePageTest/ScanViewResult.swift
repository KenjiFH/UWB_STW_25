//
//  ScanViewResult.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//




import SwiftUI

let userDefaults = UserDefaults.standard
let key = "myArrayKey" // Replace with your desired key
var existingArray = UserDefaults.standard.array(forKey: key) as? [String] ?? []





func EmptyArry() -> Int {
    UserDefaults.standard.set([], forKey: key)
    print("Array with key '\(key)' has been directly set to empty.")
    return 1;
}

func updateArray(upc : String) -> Int {
    let newItem = "new item to add"
    existingArray.append(upc)
    UserDefaults.standard.set(existingArray, forKey: key)
    print(existingArray)
    return 1;
}

struct ScanResultView: View {
    var code: String
    
    var body: some View {
       // let b = EmptyArry()
        let a = updateArray(upc: code)
        VStack(spacing: 20) {
            Text("Scanned Code, Item added to Impact tab")
                .font(.title)
            Text(code)
                .font(.headline)
                .foregroundColor(.blue)

            Button("Close") {
                // Dismisses the sheet
                // SwiftUI auto-dismisses when isShowingResult = false
            }
        }
        .padding()
        
    }
}






