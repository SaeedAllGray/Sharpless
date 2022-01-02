//
//  LiveTextViewModel.swift
//  Sharpless
//
//  Created by Media Davarkhah on 10/5/1400 AP.
//


import SwiftUI
import SoundAnalysis
import Speech

@available(iOS 15.0, *)
final class LiveTextViewModel: ObservableObject {
    
    static var shared = LiveTextViewModel()
    
   
    @Published var soundBanner = BannerModifier.BannerData(title: "", subtitle: "", type: .Error)
    @Published var showBanner: Bool = false
    @Published var isRecording = false
    @Published var text: String = "Tap the mic to start!"
     var soundsHistory = [recognizedSound]() {
        didSet {
            
            DispatchQueue.main.async { [self] in
                let lastIndex = soundsHistory.endIndex - 1
                let lastSound = soundsHistory[lastIndex]
                let bannerData = BannerModifier.BannerData(title: lastSound.name, subtitle: lastSound.time, type: .Info)
                showBanner = true
                soundBanner = bannerData
                
            }
            
        }
    }
    
    
    // speechRecognition-related properties
    private var name: String
    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!
   
    // soundAnalysis-related properties
    //private let soundAudioEngine: AVAudioEngine = AVAudioEngine()
    private let inputBus: AVAudioNodeBus = AVAudioNodeBus(1)
    private var inputFormat: AVAudioFormat!
    private var streamAnalyzer: SNAudioStreamAnalyzer!
    private let resultsObserver = SoundResultsObserver()
    private let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")

    private init() {
        self.name = "Peter"
    }
    
    // private methods
    private func handleError(withMessage message: String) {
        // Present an alert.
        print(message)
        // Disable record button.
       
    }
    private func prepareSpeechRequest() {
        
        // Speech recognition
        speechRecognizer = SFSpeechRecognizer()
        guard let speechRecognizer = speechRecognizer , speechRecognizer.isAvailable else {
            handleError(withMessage: "Speech recognizer not available.")
            return
        }
        
        // Create the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            handleError(withMessage: "Could not make request")
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            (result, error) in
            guard let res = result?.bestTranscription.formattedString else {
                return
            }
            let heyName = "hey \(self.name)"
            let HeyName = "Hey \(self.name)"
            if res.contains(heyName) || res.contains(HeyName)  {
                // TODO: notify vibrator Motor
                if let range = res.range(of: heyName){
                    let heyText = heyName + res[range.upperBound...]
                    self.text = String(heyText)
                } else if let range = res.range(of: HeyName) {
                    let heyText = HeyName + res[range.upperBound...]
                    self.text = String(heyText)
                  
                }
            }

            if error != nil  {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                self.inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
            
        }
    }
    fileprivate func setupAudioEngine() throws {
       
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
        if #available(iOS 15.0, *) {
            // speech
            let request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1)
            // sound
            try streamAnalyzer.add(request,
                                   withObserver: resultsObserver)
         
            
        } else {
            // Fallback on earlier versions
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, time in
            self.recognitionRequest?.append(buffer)
            self.analysisQueue.async {
                self.streamAnalyzer.analyze(buffer,
                                            atAudioFramePosition: time.sampleTime)
            }
        }
        audioEngine.prepare()
    }
    
    fileprivate func activateAudioSession() throws {
        // Activate the session
        audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        try audioEngine.start()
    }
    
    private func speechAndSoundAnalysis() throws{
        prepareSpeechRequest()
        try setupAudioEngine()
        try activateAudioSession()
    }

    func start() {
        do {
            try speechAndSoundAnalysis()
        } catch {
            print("Error: could not start detection")
        }
    }
    func stop() {
        // End the recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // Stop recording.
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        // Stop the session
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error: could not stop detection")
        }
        audioSession = nil
    }


    func soundAnalysisToggle() {
        if  !isRecording {
            start()
            isRecording.toggle()
        } else {
            stop()
            isRecording.toggle()
            showBanner = false
        }
    }
}
