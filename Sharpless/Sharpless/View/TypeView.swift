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
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    let synth = AVSpeechSynthesizer()
    @State var theUtterance = AVSpeechUtterance(string: "")
    @State var orientation = UIDevice.current.orientation
    @State private var buttonImage = "play.circle"
    @State private var text: String = ""
    @State private var backgroundColor: Color = .white
    @FocusState private var keyboardIsFocused: Bool
    @Environment(\.dismiss) var dismiss
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

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
        .accentColor(.mint)
        .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
            keyboardIsFocused = false
            if (orientation.isLandscape) {
                backgroundColor = .mint
            } else {
                backgroundColor = .white
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
