//
//  SettingView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingView: View {
    @State var pattern = Pattern(string: "")
    @State private var showGreeting = true
    @State var value: Double = 10
    @State private var showingAlert = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingViewModel: SettingViewModel
    @State private var fontSize: Double = 0
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                List {
                    Section {
                        HStack {
                            Text("Nansie Battery")
                            Spacer()
                            BatteryView(voltage: settingViewModel.battery)
                        }
                        .onAppear(perform: {
                            settingViewModel.setBattery()
                        })
                    }
                    Section (header: Text("Text Size")) {
                        Slider(value: $settingViewModel.fontSize, in: 10...100){
                            Text("Speed")
                        } minimumValueLabel: {
                            Image(systemName: "textformat.size.smaller")
                        } maximumValueLabel: {
                            Image(systemName: "textformat.size.larger")
                        }
//                            .padding()
                    }
                    Section(header: Text("Preferences")) {
                        Toggle("LED", isOn: $settingViewModel.ledON)
                        Toggle("Vibration", isOn: $settingViewModel.vibrationON)
                    }
                    Section (header: Text("Nansie")) {
                       
                        Button("Software Version") {
                             
                        }
                        
                        NavigationLink(destination: EventListView()) {
                            Text("Events")
                        }
                        .navigationTitle("Setting")
                        Button("Clear data") {
                            showingAlert = true
                        }
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete the whole data?"),
                                message: Text("There is no undo."),
                                primaryButton: .destructive(Text("Delete")) {
                                    settingViewModel.clearData()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    
                    
                }.listStyle(InsetGroupedListStyle())
            }
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
                        settingViewModel.saveSetting()
                        dismiss()
                    }
                    
                }
            }
        }
        //            .accentColor(.teal)
        
        
        
        .accentColor(.teal)
        .environmentObject(settingViewModel)
    }
    
    
}
@available(iOS 15.0, *)
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
