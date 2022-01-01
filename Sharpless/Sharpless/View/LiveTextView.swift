//
//  LiveTextViewModel.swift
//  Sharpless
//
//  Created by Media Davarkhah on 10/5/1400 AP.
//


import SwiftUI
import AVFoundation
import SoundAnalysis
import Speech



@available(iOS 15.0, *)
struct LiveTextView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @ObservedObject var liveTextViewModel = LiveTextViewModel.shared
    @State private var showingSettingView = false
    @State private var showingTypeView = false
    @State var text: String = "Tap the mic to start!"
    @State private var backgroundColor: Color = .clear
    @State private var foregroundColor = UIColor.label
    @State private var isRecording = false
    //@ObservedObject private var soundAnalysis = SoundAndSpeechDetector(name: "Peter")
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
                    Spacer(minLength: 65)
                    ScrollView {
                        TextEditor(text: $liveTextViewModel.text)
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
                            liveTextViewModel.soundAnalysisToggle()
                        } label: {
                            if !liveTextViewModel.isRecording {
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
            
            .banner(data: $liveTextViewModel.soundBanner, show: $liveTextViewModel.showBanner)
      
           
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
