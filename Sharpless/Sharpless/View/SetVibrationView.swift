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
    @State var pattern = [Vibration]()
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text("Design the pattern you desire to trigger when iPhone identified the event.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                PatternView(pattern: $pattern)
                    .padding()
                HStack {
                    Button {
                        self.pattern = []
                    } label: {
                        Image(systemName: "trash.circle")
                            .font(.system(size: 30))
                    }
                   
                    Button {
                        testVibration()
                    } label: {
                        Image(systemName: "play.circle")
                            .font(.system(size: 30))
                    }
                    .disabled(pattern.count < 5)
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
                        pattern.append( Vibration.short)
                       
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
                        pattern.append(Vibration.long)
                        print("ljdkfjerkfjrkjfhekjr")
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                    
                }
                .disabled(pattern.count == 5)
            }
            
        }
        .navigationTitle("Vibration")
        .toolbar {
            Button("Save") {
              
            }
        }
        
    }
    func testVibration() {
      
    }
}
@available(iOS 15.0, *)
struct MakeVibrationView_Previews: PreviewProvider {
    static var previews: some View {
        SetVibrationView(pattern: [.short,.long,.long,.long,.short])
    }
}
