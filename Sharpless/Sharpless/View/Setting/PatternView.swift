//
//  PatternView.swift
//  Sharpless
//
//  Created by saeed on 12/3/21.
//

import SwiftUI


struct PatternView: View {
    var pattern: Pattern
    var unassignedImage = Image(systemName: "capsule.portrait")
    var assignedImage = Image(systemName: "capsule.portrait.fill")
    var shortVibrationColor = Color.blue
    var longVibrationColor = Color.red
    var body: some View {
        HStack {
            ForEach (0..<5, id: \.self) { number in
                
                self.image(for: number)
                    .foregroundColor(number < pattern.vibrationList.count ? self.color(for: pattern.vibrationList[number]):Color.primary)
            }
        }
        
    }
    
    func image(for number: Int) -> Image {
        if number < pattern.vibrationList.count {
            return assignedImage
        }
         else {
            return unassignedImage
        }
    }
    func color(for vibration: Vibration) -> Color {
       
        if vibration == .short {
            return Color.blue
        } else {
            return Color.red
        }
    }
    
}

struct PatternView_Previews: PreviewProvider {
    static var previews: some View {
        PatternView(pattern: Pattern(string: "slsls"))
    }
}
