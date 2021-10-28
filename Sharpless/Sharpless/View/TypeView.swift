//
//  TypeView.swift
//  Sharpless
//
//  Created by saeed on 10/27/21.
//

import SwiftUI
import AVFoundation
@available(iOS 15.0, *)
struct TypeView: View {
    
    let synth = AVSpeechSynthesizer()
    @State var theUtterance = AVSpeechUtterance(string: "")
    
    @State private var buttonImage = "play.circle"
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss
   
    var body: some View {
        
        VStack  {
            
            ScrollView {
                TextEditor(text:$text)
                    .frame(height: 400)
                    .font(.system(size: 40))
                    .background(.mint)
                    .padding(10)
                
            }
            
            Spacer()
            HStack (spacing: 50) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right.circle")
                        .font(.system(size: 40))
                }
                
                Button(action: speak) {
                    
                    Image(systemName: buttonImage)
                        .font(.system(size: 40))
                       
                }
            }
            .padding()
        }
        .accentColor(.mint)
        
        
    }
    func speak() {
      
        buttonImage = "pause.circle"
        // unpause
        if (synth.isPaused) {
            synth.continueSpeaking();
        }
        // pause
        else if (synth.isSpeaking) {
            synth.pauseSpeaking(at: .word)
            buttonImage = "play.circle"
        }
        // start
        else if (!synth.isSpeaking) {
            theUtterance = AVSpeechUtterance(string: text)
            theUtterance.rate = 0.5
            synth.speak(theUtterance)
            
        }
        
       
    }
}

@available(iOS 15.0, *)
struct TypeView_Previews: PreviewProvider {
    static var previews: some View {
        TypeView()
    }
}
