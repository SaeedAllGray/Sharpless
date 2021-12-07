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
    var event: String
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text("Design the pattern you desire to trigger when iPhone identified the event.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(10)


                
                SetPatternView(pattern: $setPatterViewModel.pattern)
                    .padding()
                Spacer()
                HStack {
                    Button {
                        setPatterViewModel.clearPattern()
                    } label: {
                        Image(systemName: "trash.circle")
                            .font(.system(size: 30))
                    }
                   
                    Button {
                        setPatterViewModel.testPattern()
                    } label: {
                        Image(systemName: "play.circle")
                            .font(.system(size: 30))
                    }
                    .disabled(!setPatterViewModel.shouldActiveSaveButton())
                }
                
                Spacer()
                
                
                HStack (spacing:0) {
                    ZStack{
                        Color.blue
                            .ignoresSafeArea()
                        Text("Short Vibration")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: geometry.size.width/2, height: 250)
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
                    
                    .frame(width: geometry.size.width/2, height: 250,alignment: .center)
                    
                    //                 .cornerRadius(10)
                    //                .clipped()
                    .onTapGesture {
                        setPatterViewModel.pattern.vibrationList.append(Vibration.long)
                        print("ljdkfjerkfjrkjfhekjr")
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                    
                }
                .disabled(setPatterViewModel.shouldActiveSaveButton())
            }
            
        }

        .navigationTitle(self.event)
        .toolbar {
            Button("Save") {
                setPatterViewModel.savePattern(event: self.event, pattern: setPatterViewModel.pattern)
                
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
