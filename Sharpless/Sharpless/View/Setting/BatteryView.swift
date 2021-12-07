//
//  BatteryView.swift
//  Sharpless
//
//  Created by saeed on 12/3/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct BatteryView: View {
    var voltage: Double
    var body: some View {
        if voltage > 3.9 {
            Image(systemName: "battery.100")
                .foregroundColor(.green)
                .font(.system(size: 30))
        }
        else if(voltage > 3.7) {
            Image(systemName: "battery.50")
            
                .foregroundColor(.cyan)
                .font(.system(size: 20))
                
        }
        else {
            Image(systemName: "battery.0")
                .foregroundColor(.red)
                .font(.system(size: 20))
        }
    }
}

@available(iOS 15.0, *)
struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView(voltage: 4)
    }
}
