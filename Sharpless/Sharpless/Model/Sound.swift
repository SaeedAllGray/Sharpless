//
//  Sound.swift
//  Sharpless
//
//  Created by saeed on 11/3/21.
//

import Foundation

struct Sound {
    var name: String
    var vibrationPattern: String = "v<300>s<100>"
    
    // #
}

class recognizedSound {

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


