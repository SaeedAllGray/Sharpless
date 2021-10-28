//
//  LiveTextView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct LiveTextView: View {
    @State private var showingSettingView = false
    @State private var showingTypeView = false
    @State var text: String = "Live listen is ready!"
    @State var orientation = UIDevice.current.orientation
    @State private var isShareViewPresented: Bool = false
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    var body: some View {
        
        ZStack {
            if orientation.isLandscape {
                Color.mint
                    .ignoresSafeArea()
            }
            VStack {
                ScrollView {
                    TextEditor(text:$text)
                        .frame(height: 400)
                        .font(.system(size: 40))
                        .background(.mint)
                        .padding(10)
                        
                    
                }
                
                HStack {
                    
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
                        print("Edit button was tapped")
                    } label: {
                        Image(systemName: "mic.circle.fill")
                            .font(.system(size: 60))
                        //                            .padding()
                    }
                    Button {
                        showingSettingView.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $showingSettingView) {
                        SettingView()
                    }
                    Button(action: actionSheet) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 30))
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    
                }
                
                .padding(20)
                
                
                
            }
        }
        .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
            
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
            .previewInterfaceOrientation(.portrait)
    }
}
