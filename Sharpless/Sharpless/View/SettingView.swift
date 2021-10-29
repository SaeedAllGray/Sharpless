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
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                List {
                    Section{
                        Text("Font Size")
                        
                        Slider(value: $settingViewModel.fontSize, in: 10...100)
                            .padding()
                        
                        
                    }
                    
                    Section
                    {
                        Text("Siren")
                        Text("Door Bell")
                        Text("Door Knock")
                        Text("Your Name")
                        
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
            .environmentObject(settingViewModel)
            .accentColor(.teal)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SettingView()
        } else {
            // Fallback on earlier versions
        }
    }
}
