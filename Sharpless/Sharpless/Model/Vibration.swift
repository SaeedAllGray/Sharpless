//
//  Vibration.swift
//  Sharpless
//
//  Created by saeed on 11/12/21.
//

import Foundation

enum Vibration: String {
    case short = "s"
    case long = "l"
    case unknown = ""
}
struct recognizedSound {
    var name: String
    var vibrationPattern: String
    var time: String
    
    init(name: String, vibrationPatter: String = "v<300>s<100>", time: String) {
        self.name = name
        self.vibrationPattern = vibrationPatter
        self.time = time
    }
    
    // #
}

struct soundHistory {
    static var soundsHistory = [recognizedSound]()
    
}
