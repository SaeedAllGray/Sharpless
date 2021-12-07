//
//  Pattern.swift
//  Sharpless
//
//  Created by saeed on 12/2/21.
//

import Foundation

struct Pattern {
    var vibrationList: [Vibration]
    
    func getString() -> String {
        var pattern = ""
        for vibration in vibrationList {
            pattern.append(vibration.rawValue)
        }
        return pattern
    }

    init(string: String) {
        vibrationList = []
        for ch in string {
            if(ch == "s") {
                vibrationList.append(Vibration.short)
            } else {
                vibrationList.append(Vibration.long)
            }
        }
    }
}

//extension Pattern {
//    static func moc() -> Pattern {
//        return Pattern(string: "sslss"))
//    }
//}
