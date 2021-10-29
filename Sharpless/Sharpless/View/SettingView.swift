//
//  SettingView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var fontSize: Double = 0

    
    var body: some View {
        NavigationView {
            VStack {
                
               
                List {
                    Section{
                        Text("Font Size")
                        
                        Slider(value: $fontSize, in: 10...100) { _ in
                            UserDefaults.standard.setValue(fontSize, forKey: "font")
                            fontSize = UserDefaults.standard.value(forKey: "font") as? Double ?? 0
                        }
                    
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
            .accentColor(.mint)
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
                        dismiss()
                    }
                    
                }
            }
            .accentColor(.mint)
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
