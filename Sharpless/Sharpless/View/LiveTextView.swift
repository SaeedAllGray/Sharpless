//
//  LiveTextView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI
import AVFoundation
import SoundAnalysis
import Speech

@available(iOS 15.0, *)
struct LiveTextView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @State private var showingSettingView = false
    @State private var showingTypeView = false
    @State var text: String = "Tap the mic to start!"
    @State private var backgroundColor: Color = .clear
    @State private var foregroundColor = UIColor.label
    @State private var isRecording = false
    @ObservedObject private var soundAnalysis = SoundAndSpeechDetector(name: "Peter")
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
                        TextEditor(text: $soundAnalysis.text)
                            .allowsHitTesting(false)
                            .font(.system(size: settingViewModel.fontSize))
                            .background(backgroundColor)
                            .padding(10)
                    }
                    .background(backgroundColor)
                    
                    HStack (alignment: .center) {
                        Button {
                            self.text = ""
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 30))
                        }
                        Button {
                            showingTypeView.toggle()
                      
                        } label: {
                            Image(systemName: "keyboard")
                                .font(.system(size: 30))
                        }
                        .sheet(isPresented: $showingTypeView) {
                            TypeView()
                        }
                        Button {
                            if !isRecording {
                                soundAnalysis.start()
                                text = soundAnalysis.text
                                isRecording = !isRecording
                            } else {
                                soundAnalysis.stop()
                                isRecording = !isRecording
                            }
                        } label: {
                            if !isRecording {
                                Image(systemName: "mic.circle.fill")
                                    .font(.system(size: 60))
                                
                            } else {
                                Image(systemName: "record.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                                
                            }
                        }
                        
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
                    .background(backgroundColor)
                    .padding(10)
                }
                .background(backgroundColor)
            }
            .background(backgroundColor)
            
            .onReceive(orientationChanged) { _ in
                self.orientation = UIDevice.current.orientation
                if (orientation.isLandscape) {
                    backgroundColor = .verte
                    foregroundColor = UIColor.white
                } else {
                    backgroundColor = .clear
                    foregroundColor = .systemTeal
                    
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
    private func handlePermissionFailed() {
        // TODO: Present an alert asking the user to change their settings.
    }
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
    
        
    
    
  
}
@available(iOS 15.0, *)
struct LiveTextView_Previews: PreviewProvider {
    
    static var previews: some View {
        LiveTextView()
            .previewInterfaceOrientation(.portrait)
    }
}
