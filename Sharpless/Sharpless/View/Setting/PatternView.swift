//
//  PatternView.swift
//  Sharpless
//
//  Created by saeed on 12/3/21.
//

import SwiftUI


struct PatternView: View {
    var pattern: Pattern
    var body: some View {
        HStack {
            ForEach(pattern.vibrationList, id: \.self) { vibration in
                Image(systemName: "bolt.circle")
                    .foregroundColor(vibration == .short  ? Color.blue : Color.red)
            }
        }
    }
}

struct PatternView_Previews: PreviewProvider {
    static var previews: some View {
        PatternView(pattern: Pattern(string: "slsls"))
    }
}
