//
//  SettingView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        
        Form {
            Text("Siren")
            Text("Door Bell")
            Text("Knock Knock")
        }.listStyle(InsetGroupedListStyle())
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
