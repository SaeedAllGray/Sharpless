//
//  SettingModelView.swift
//  Sharpless
//
//  Created by saeed on 10/26/21.
//

import SwiftUI

final class SettingViewModel: ObservableObject {
    @Published var fontSize: Double = 20
    
    let defaults = UserDefaults.standard
    
    init() {
        fontSize = defaults.double(forKey: "font size")
    }
    func setFontSize() {
        defaults.set(fontSize, forKey: "font size")
    }
    func saveToUserDefaults<T>(key: String, value: T) {
        
    }
}
