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
    @State var theUtterance = AVSpeechUtterance(string: "")
    @State var orientation = UIDevice.current.orientation
    @State private var buttonImage = "play.circle"
    @State private var text: String = ""
    @State private var backgroundColor: Color = .clear
    @FocusState private var keyboardIsFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    let synth = AVSpeechSynthesizer()
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
   

    var body: some View {

        VStack  {
            
            ScrollView {
                TextEditor(text:$text)
                    .frame(height: 400)
                    .font(.system(size: 40))
                    .background(backgroundColor)
                    .padding()
                    .focused($keyboardIsFocused)
            }
            .background(backgroundColor)
            
            Spacer()
            HStack (spacing: 50) {
                
                Button(action: speak) {
                    
                    Image(systemName: buttonImage)
                        .font(.system(size: 40))
                       
                }
            }
            .padding()
            .background(backgroundColor)
        }
        .background(backgroundColor)
        .accentColor(.teal)
        .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
            keyboardIsFocused = false
            if (orientation.isLandscape) {
                backgroundColor = .verte
            } else {
                backgroundColor = .clear
            }
            
        }
        
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
