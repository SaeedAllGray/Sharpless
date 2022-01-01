//
//  MakeVibrationView.swift
//  Sharpless
//
//  Created by saeed on 11/8/21.
//

import SwiftUI
import AudioToolbox

@available(iOS 15.0, *)

struct SetVibrationView: View {
    @ObservedObject var setPatterViewModel = SetPatternViewModel()
    @State var event: String = ""
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        GeometryReader { geometry in
            
            List {
                Section(header: Text("Events")) {
                    EventPicker(event: $event)
                    
                        .listRowInsets(EdgeInsets())
                    
                }
                
                
                Section(header: Text("Vibration"),footer: Text("Design the pattern you desire to trigger when iPhone identified the event.")){
                    Button("Clear") {
                        setPatterViewModel.clearPattern()
                    }
                    //                    .disabled(!setPatterViewModel.shouldActiveSaveButton())
                    
                    HStack(alignment: .center) {
                        Button("Perform") {
                            setPatterViewModel.testPattern()
                        }
                        .disabled(!setPatterViewModel.shouldActiveSaveButton())
                        
                        Spacer()
                        SetPatternView(pattern: $setPatterViewModel.pattern)
                        
                    }
                    VStack {
                        
                        //Spacer()
                        //                        HStack {
                        //                            Button {
                        //                                setPatterViewModel.clearPattern()
                        //                            } label: {
                        //                                Image(systemName: "trash.circle")
                        //                                    .font(.system(size: 30))
                        //                            }
                        //
                        //                            Button {
                        //                                setPatterViewModel.testPattern()
                        //                            } label: {
                        //                                Image(systemName: "play.circle")
                        //                                    .font(.system(size: 30))
                        //                            }
                        //                            .disabled(!setPatterViewModel.shouldActiveSaveButton())
                        //                        }
                        //                        .padding()
                        
                        HStack (spacing:0) {
                            ZStack{
                                Color.blue
                                    .ignoresSafeArea()
                                Text("Short Vibration")
                                    .foregroundColor(.white)
                            }
                            
                            //                            .frame(width: geometry.size.width/2, height: 100)
                            //                 .cornerRadius(10)
                            //                .clipped()
                            .onTapGesture {
                                setPatterViewModel.pattern.vibrationList.append( Vibration.short)
                                
                                impactMed.impactOccurred()
                            }
                            ZStack{
                                Color.red
                                    .ignoresSafeArea()
                                Text("Long Vibration")
                                    .foregroundColor(.white)
                                
                            }
                            
                            //                            .frame(width: geometry.size.width/3, height: 100,alignment: .center)
                            
                            //                 .cornerRadius(10)
                            //                .clipped()
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                setPatterViewModel.pattern.vibrationList.append(Vibration.long)
                                print("ljdkfjerkfjrkjfhekjr")
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                            
                        }
                        .disabled(setPatterViewModel.shouldActiveSaveButton())
                        
                    }
//                    .frame(width: .infinity,height: 100)
                    .cornerRadius(10)
                    
                    
                }
                
                
                
            }
            //            .listStyle(InsetGroupedListStyle())
            
        }
        
        .navigationTitle(self.event)
        .toolbar {
            
            
            Button("Save") {

                setPatterViewModel.savePattern(event: self.event, pattern: setPatterViewModel.pattern)
//                dismiss()
                
            }
            .disabled(!setPatterViewModel.shouldActiveSaveButton())
        }
        
    }
}
@available(iOS 15.0, *)
struct MakeVibrationView_Previews: PreviewProvider {
    static var previews: some View {
        SetVibrationView(event: "say my name")
    }
}
