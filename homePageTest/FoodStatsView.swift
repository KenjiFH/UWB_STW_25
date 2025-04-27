//
//  FoodStatsView.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/27/25.
//

import SwiftUI




func printList() -> Double {
    print(UserDefaults.standard.array(forKey: key) as? [String] ?? [])
    return 0.0
}



struct FoodStatsView: View {
    //@State private var upcList: [String] = UserDefaults.standard.array(forKey: "myArrayKey") as? [String] ?? []
    @State private var scanResults: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    var upcList = UserDefaults.standard.array(forKey: key) as? [String] ?? []
    
    let carbonScoreKey = "totalCarbonImpactScore"
    
    func updateCarbonScore(by amount: Double) {
        let currentScore = getTotalCarbonScore()
        
        let newScore = currentScore + amount
        
        
        UserDefaults.standard.set(newScore, forKey: carbonScoreKey)
        print("Carbon score updated to: \(newScore)")
    }
    
    
    func getTotalCarbonScore() -> Double {
        return UserDefaults.standard.double(forKey: carbonScoreKey)
    }

    var body: some View {
        VStack {
            Text("Food Waste List")
                .font(.title)
                .padding()

            if isLoading {
              
                ProgressView("Fetching Data...")
            } else if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(scanResults, id: \.self) { resultText in
                            Text(resultText)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }

            Button("Load Food Waste Data") {
                print(upcList)
                fetchDataForUPCs()
            }
            .padding()
            .disabled(isLoading || upcList.isEmpty)

            if upcList.isEmpty {
                Text("No UPC codes saved in UserDefaults.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            // Load UPCs when the view appears (you might have a different way to populate)
            if UserDefaults.standard.array(forKey: "myArrayKey") == nil {
               // UserDefaults.standard.set(["123456789012", "987654321098"], forKey: "myArrayKey")
                //upcList = UserDefaults.standard.array(forKey: "myArrayKey") as? [String] ?? []
            }
        }
    }

    func fetchDataForUPCs() {
        isLoading = true
        errorMessage = nil
        scanResults.removeAll() // Clear previous results

        let dispatchGroup = DispatchGroup()

        for upc in upcList {
            dispatchGroup.enter() // Increment the counter

            foodAPICall(upc: upc) { result in
                let resultText = "UPC: \(upc)\nName: \(result.name)\nEmissions: \(String(format: "%.2f", result.emissionsVal))\nCountry: \(result.country)\nPlant-Based: \(result.isPlantBased ? "Yes" : "No")\n"
                
                
                DispatchQueue.main.async {
                    scanResults.append(resultText)
                    updateCarbonScore(by: result.emissionsVal)
                }
                dispatchGroup.leave() // Decrement the counter
            }
        }

        dispatchGroup.notify(queue: .main) {
            isLoading = false // All API calls have completed
            
        }
    }
}

// Assuming your FoodScanResult struct and foodAPICall function are defined elsewhere
// struct FoodScanResult { ... }
// func foodAPICall(upc: String, callback: @escaping (FoodScanResult) -> Void) { ... }







//food thing ashidfj
import Foundation

class FoodCarbonEmissions {
    static let proteinEFPlant = 0.01
    static let proteinEFNonPlant = 0.1
    static let carbsEFPlant = 0.005
    static let carbsEFNonPlant = 0.03
    static let fatEFPlant = 0.002
    static let fatEFNonPlant = 0.002

    var isPlantBased = false
    var proteinCount = -1.0
    var carbsCount = -1.0
    var fatCount = -1.0

    func calc() -> Double {
        if isPlantBased {
            return (proteinCount * FoodCarbonEmissions.proteinEFPlant) +
                   (carbsCount * FoodCarbonEmissions.carbsEFPlant) +
                   (fatCount * FoodCarbonEmissions.fatEFPlant)
        } else {
            return (proteinCount * FoodCarbonEmissions.proteinEFNonPlant) +
                   (carbsCount * FoodCarbonEmissions.carbsEFNonPlant) +
                   (fatCount * FoodCarbonEmissions.fatEFNonPlant)
        }
    }
}



struct FoodScanResult {
    var name = ""
    var emissionsVal = -1.0
    var country = ""
    var isPlantBased = false

    init(nameIn: String, emissionsValIn: Double, countryIn: String, isPlantBasedIn: Bool) {
        name = nameIn
        emissionsVal = emissionsValIn
        country = countryIn
        isPlantBased = isPlantBasedIn
    }
}

func isPlantBased(productJson: [String: Any]) -> Bool {
    if let keywords = productJson["_keywords"] as? [String] {
        for value in keywords {
            if value == "plant-based" || value == "plant_based" {
                return true
            }
        }
    }
    return false
}

func doUrlGET(urlStr: String, completion: @escaping (Data) -> Void) {
    if let url = URL(string: urlStr) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            if let data = data {
                completion(data)
            }
        }.resume()
    } else {
        print("Invalid URL: \(urlStr)")
    }
}

func foodAPICall(upc: String, callback: @escaping (FoodScanResult) -> Void) {
    doUrlGET(urlStr: "https://world.openfoodfacts.org/api/v0/product/\(upc).json") { data in
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let emissionsObj = FoodCarbonEmissions()
                var productName = ""
                var country = ""

                if let product = jsonObject["product"] as? [String: Any] {
                    print("Searching Product Fields:")

                    if let productName_ = product["product_name"] as? String {
                        print("Product Name: \(productName_)")
                        productName = productName_
                    }

                    if let brands = product["brands"] as? String {
                        print("Brands: \(brands)")
                    }

                    if let brandOwner = product["brand_owner"] as? String { // Corrected typo
                        print("Brand Owner: \(brandOwner)")
                    }

                    if isPlantBased(productJson: product) {
                        print("Is plant based")
                        emissionsObj.isPlantBased = true
                    } else {
                        print("Is NOT plant based")
                        emissionsObj.isPlantBased = false
                    }

                    if let nutriments = product["nutriments"] as? [String: Any] {
                        if let proteins = nutriments["proteins_100g"] as? Double {
                            print("Proteins (100g): \(proteins)")
                            emissionsObj.proteinCount = proteins
                        }
                        if let carbs = nutriments["carbohydrates_100g"] as? Double {
                            print("Carbohydrates (100g): \(carbs)")
                            emissionsObj.carbsCount = carbs
                        }
                        if let fats = nutriments["fat_100g"] as? Double {
                            print("Fats (100g): \(fats)")
                            emissionsObj.fatCount = fats
                        }
                    } else {
                        print("No nutriments found.")
                    }

                    if let ecoscoreData = product["ecoscore_data"] as? [String: Any],
                       let adjustments = ecoscoreData["adjustments"] as? [String: Any],
                       let originsOfIngredients = adjustments["origins_of_ingredients"] as? [String: Any],
                       let originsArr = originsOfIngredients["origins_from_origins_field"] as? [String],
                       let firstCountry = originsArr.first { // Safely get the first country
                        country = firstCountry
                        print("Country of Origin: \(firstCountry)")
                    } else {
                        print("Country of Origin not found.")
                    }
                } else {
                    print("Product not found in API")
                }

                callback(FoodScanResult(nameIn: productName, emissionsValIn: emissionsObj.calc(), countryIn: country, isPlantBasedIn: emissionsObj.isPlantBased))
            } else {
                print("Error: Could not parse JSON data into a dictionary.")
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
}
