//
//  ContentView.swift
//  UIRepository
//
//  Created by Tim Walsh on 4/8/24.
//

import SwiftUI

struct ColorScheme: Codable {
    let lightPrimary: String
    let lightOnPrimary: String
    let darkPrimary: String
    let darkOnPrimary: String
    
    init(ColorModel: ColorModel) {
        self.lightPrimary = ColorModel.lightPrimary
        self.lightOnPrimary = ColorModel.lightOnPrimary
        self.darkPrimary = ColorModel.darkPrimary
        self.darkOnPrimary = ColorModel.darkOnPrimary
    }
    // Default initializer with default colors
    init(lightPrimary: String = "FF000000",
         lightOnPrimary: String = "FFFFFFF",
         darkPrimary: String = "FF000000",
         darkOnPrimary: String = "FFFFFFF") {
        self.lightPrimary = lightPrimary
        self.lightOnPrimary = lightOnPrimary
        self.darkPrimary = darkPrimary
        self.darkOnPrimary = darkOnPrimary
    }
}

struct ResponseModel: Codable {
    let record: ColorModel
}

struct ColorModel: Codable {
    let lightPrimary: String
    let lightOnPrimary: String
    let darkPrimary: String
    let darkOnPrimary: String

    private enum CodingKeys: String, CodingKey {
        case lightPrimary = "light_primary"
        case lightOnPrimary = "light_on_primary"
        case darkPrimary = "dark_primary"
        case darkOnPrimary = "dark_on_primary"
    }
}

struct ContentView: View {
    
    @State private var colorModel: ColorModel?
    @State private var colorScheme: ColorScheme = ColorScheme()
    
    // Parse JSON data into ColorScheme struct
    
    
    var body: some View {
        VStack {
            Button(action: {
                fetchData(from: "https://api.jsonbin.io/v3/b/6615a7cdacd3cb34a835fbed/latest")
            }) {
                Text("Color Scheme 1")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                fetchData(from: "https://api.jsonbin.io/v3/b/6614765be41b4d34e4e15ad4/latest")
            }) {
                Text("Color Scheme 2")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                // Button action
            }) {
                Text("Light Mode Primary")
                    .foregroundColor(Color(hex: colorScheme.lightOnPrimary))
                    .padding()
                    .background(Color(hex: colorScheme.lightPrimary))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                // Button action
            }) {
                Text("Dark Mode Primary")
                    .foregroundColor(Color(hex: colorScheme.darkOnPrimary))
                    .padding()
                    .background(Color(hex: colorScheme.darkPrimary))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            }
        .onAppear {
            // Delay fetching data by 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                fetchData(from: "https://api.jsonbin.io/v3/b/6614765be41b4d34e4e15ad4/latest")
            }
        }
    }
    func fetchData(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                } else {
                    print("Empty response")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ResponseModel.self, from: data)
                print("color: \(decodedData.record)")
                self.colorScheme = ColorScheme(ColorModel: decodedData.record)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

// SwiftUI extension to create Color from hex string
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        self.init(
            .sRGB,
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0,
            opacity: 1
        )
    }
}

#Preview {
    ContentView()
}
