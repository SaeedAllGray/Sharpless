//
//  SettingModelView.swift
//  Sharpless
//
//  Created by saeed on 10/26/21.
//

import SwiftUI
import SoundAnalysis

@available(iOS 15.0, *)
final class SettingViewModel: ObservableObject {
    @Published var ledON: Bool
    @Published var vibrationON: Bool
    @Published var battery: Double = 0
    
    @Published var fontSize: Double = 20
    @Published var name: String = ""
    @Published var patternList: [Pattern] = []
    @Published var loadingState: LoadState = .notLoaded
    
    
    @Published var eventList: [String] = {
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1)
            return request.knownClassifications
        } catch {
            
        }
        return []
    }()
    
    
    let defaults = UserDefaults.standard
    
    init() {
        
        fontSize = defaults.double(forKey: "font size")
        ledON = defaults.bool(forKey: "LED")
        vibrationON = defaults.bool(forKey: "vibration")
        if let name = UserDefaults.standard.string(forKey: "Name") {
            self.name = name
        }
    }
    func setFontSize() {
        defaults.set(fontSize, forKey: "font size")
    }
    func setName() {
        defaults.set(name, forKey: "Name")
    }
    
    func setAllPatterns() {
        loadingState = .loading
        let url = URL(string: "http://192.168.1.134/data")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
        
    }
    
    func saveSetting() {
        defaults.set(fontSize, forKey: "font size")
        defaults.set(ledON, forKey: "LED")
        defaults.set(vibrationON, forKey: "vibration")
        setName()
        let ledValueToSave = ledON ? 1 : 0
        let vibrationValueToSave = vibrationON ? 1 : 0
        let url = URL(string: "http://192.168.1.134/setting?led=\(ledValueToSave)&vibration=\(vibrationValueToSave)")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    func clearData() {
        let url = URL(string: "http://192.168.1.134/removehistory")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    func setBattery() {
        let url = URL(string: "http://192.168.1.134/battery")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
                self.battery = Double(String(data: data, encoding: .utf8)!) ?? 0
            }
        }
        
        task.resume()
    }
    
}
