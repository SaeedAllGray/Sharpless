//
//  LiveTextView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI
import AVFoundation
import Speech

@available(iOS 15.0, *)
struct LiveTextView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @State private var showingSettingView = false
    @State private var showingTypeView = false
    @State var text: String = "Live listen is ready!"
    @State private var backgroundColor: Color = .clear
    @State private var foregroundColor = UIColor.label
    
    // speechRecognition-related properties
    @State private var isRecording = false
    @State private var speechRecognizer: SFSpeechRecognizer!
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine: AVAudioEngine!
    @State private var inputNode: AVAudioInputNode!
    @State private var audioSession: AVAudioSession!
   
    
    @State var orientation = UIDevice.current.orientation
    @State private var isShareViewPresented: Bool = false
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        checkPermissions()
        
        
    }

   
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ScrollView {
                        TextEditor(text:$text)
                            .allowsHitTesting(false)
                            .frame(height: geometry.size.height * 5 / 6)
                            .font(.system(size: settingViewModel.fontSize))
                            .background(backgroundColor)
                            .padding(10)
                    }
                    .background(backgroundColor)
                    
                    HStack (alignment: .center) {
                        //                        Spacer()
                        Button {
                            self.text = ""
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 30))
                        }
                        //                        Spacer()
                        Button {
                            showingTypeView.toggle()
                        } label: {
                            Image(systemName: "keyboard")
                                .font(.system(size: 30))
                        }
                        .sheet(isPresented: $showingTypeView) {
                            TypeView()
                        }
                        //                        Spacer()
                        Button {
                            if !isRecording {
                                do {
                                    try startRecording()
                                    isRecording.toggle()
                                } catch let error {
                                   handleError(withMessage: error.localizedDescription)
                                }
                            } else {
                                do {
                                    try stopRecognizing()
                                    isRecording.toggle()
                                } catch let error {
                                   handleError(withMessage: error.localizedDescription)
                                }
                            }
                        } label: {
                            if !isRecording {
                                Image(systemName: "mic.circle.fill")
                                    .font(.system(size: 60))
                                
                            } else {
                                Text("Stop")
                            }
                        }
                        //                        Spacer()
                        Button {
                            showingSettingView.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 30))
                        }
                        .sheet(isPresented: $showingSettingView) {
                            SettingView()
                                .environmentObject(settingViewModel)
                        }
                        //                        Spacer()
                        Button(action: actionSheet) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 30))
                                .aspectRatio(contentMode: .fit)
                            
                             
                        }
                        
                    }
                    .foregroundColor(Color(foregroundColor))
                    .background(backgroundColor)
                    .padding(10)
                }
                .background(backgroundColor)
            }
            .background(backgroundColor)
            
            .onReceive(orientationChanged) { _ in
                self.orientation = UIDevice.current.orientation
                if (orientation.isLandscape) {
                    backgroundColor = .teal
                    foregroundColor = UIColor.black
                } else {
                    backgroundColor = .clear
                    foregroundColor = UIColor.systemTeal
                    
                }
            }
            
           
        }
    }
    // MARK: -Helpers
    func actionSheet() {
        let sharedText = text
        let activityVC = UIActivityViewController(activityItems: [sharedText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    // MARK: -Privacy
    private func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                default: handlePermissionFailed()
                }
            }
        }
    }
        
    private func handlePermissionFailed() {
        // TODO: Present an alert asking the user to change their settings.
    }
    
    private func handleError(withMessage message: String) {
        // Present an alert.
        print(message)
        // Disable record button.
       
    }
    
    // MARK: -Speech Recognition
    private func startRecording() throws {
        
        // Create the Recognizer
        speechRecognizer = SFSpeechRecognizer()
        guard let speechRecognizer = speechRecognizer , speechRecognizer.isAvailable else {
            handleError(withMessage: "Speech recognizer not available.")
            return
        }
        
        // Create the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        //recognitionRequest?.shouldReportPartialResults = true
        guard let recognitionRequest = recognitionRequest else {
            handleError(withMessage: "Could not make request")
            return
        }
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            (result, error) in
            var isFinal = false
            
            if let result = result {
                text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

              
            }
            
            
        }
        
        // Set up audio engine
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let recordingFromat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFromat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        
        // Activate the session
        audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        try audioEngine.start()
        
        text = "I'm Listening"
    }

    private func stopRecognizing() throws {
        // End the recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // Stop recording.
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        // Stop the session
        try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        audioSession = nil
    }
       
}
@available(iOS 15.0, *)
struct LiveTextView_Previews: PreviewProvider {
    
    static var previews: some View {
        LiveTextView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
