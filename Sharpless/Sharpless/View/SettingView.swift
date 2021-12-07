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
                        Slider(value: $settingViewModel.fontSize, in: 10...100)
                            .padding()
                    }
                    Section(header: Text("Preferences")) {
                        Toggle("LED", isOn: $settingViewModel.ledON)
                        Toggle("Vibration", isOn: $settingViewModel.vibrationON)
                    }
                    Section (header: Text("Nansie")) {
                        HStack {
                            Text("Software Update")
                            Spacer()
                            ZStack {
                                Color.teal
                                Text("Update")
                            }
                            .foregroundColor(.primary)
                            .frame(width: 75,height: 30)
                            .clipShape(Capsule())
                            .onTapGesture {
                                
                            }
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
            
        }
        //            .accentColor(.teal)
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
