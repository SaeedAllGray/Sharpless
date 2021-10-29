//
//  LiveTextView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct LiveTextView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @State private var showingSettingView = false
    @State private var showingTypeView = false
    @State var text: String = "Live listen is ready!"
    @State private var backgroundColor: Color = .clear
    @State private var foregroundColor = UIColor.label
    
    @State var orientation = UIDevice.current.orientation
    @State private var isShareViewPresented: Bool = false
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
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
                            print("Edit button was tapped")
                        } label: {
                            Image(systemName: "mic.circle.fill")
                                .font(.system(size: 60))
                            //                            .padding()
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
    func actionSheet() {
        let sharedText = text
        let activityVC = UIActivityViewController(activityItems: [sharedText], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
@available(iOS 15.0, *)
struct LiveTextView_Previews: PreviewProvider {
    
    static var previews: some View {
        LiveTextView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
