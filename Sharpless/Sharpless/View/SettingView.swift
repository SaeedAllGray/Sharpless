//
//  SettingView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingView: View {
    @State var value: Double = 10
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingViewModel: SettingViewModel
    @State private var fontSize: Double = 0
    
    let events = ["Siren", "Door Bell", "Door Knock", "MY NAME"]
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                List {
                    Section{
                        Text("Font Size")
                        
                        Slider(value: $settingViewModel.fontSize, in: 10...100)
                            .padding()
                        
                        
                    }
                    ForEach(events,id: \.self) { event in
                        NavigationLink(destination: SetVibrationView()) {
                            Text(event)
                        }
                    }
                   
                    
                }.listStyle(InsetGroupedListStyle())
                
                
            }
            .accentColor(.teal)
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        settingViewModel.setFontSize()
                        dismiss()
                    }
                    
                }
            }
            .accentColor(.teal)
            .environmentObject(settingViewModel)
        }
    }
}
@available(iOS 15.0, *)
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
