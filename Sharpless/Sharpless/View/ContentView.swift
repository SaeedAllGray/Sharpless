//
//  ContentView.swift
//  Sharpless
//
//  Created by saeed on 10/25/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    var body: some View {
        
        LiveTextView()
            .accentColor(.mint)
        
        
    }
    
}
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
