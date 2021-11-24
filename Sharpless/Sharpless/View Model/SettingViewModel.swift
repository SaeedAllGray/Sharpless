//
//  SettingModelView.swift
//  Sharpless
//
//  Created by saeed on 10/26/21.
//

import SwiftUI

final class SettingViewModel: ObservableObject {
    @Published var fontSize: Double = 20
    @Published var name: String = "Tom"
    
    let defaults = UserDefaults.standard
    
    init() {
        fontSize = defaults.double(forKey: "font size")
        name = defaults.string(forKey: "name") ?? "Tom"
    }
    func setFontSize() {
        defaults.set(fontSize, forKey: "font size")
    }
    func setName() {
        defaults.set(name, forKey: "Name")
    }
    func saveToUserDefaults<T>(key: String, value: T) {
        
    }
}
