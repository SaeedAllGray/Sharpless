//
//  LiveTextView.swift
//  IOTApp
//
//  Created by saeed on 10/24/21.
//

import SwiftUI

struct LiveTextView: View {
    
    @State var orientation = UIDevice.current.orientation
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    var body: some View {
        NavigationView {
            ZStack {
                if orientation.isLandscape {
                    Color(#colorLiteral(red: 0, green: 0.4707520008, blue: 0.599927485, alpha: 1)).ignoresSafeArea()
                } else {
                    Color(.systemBackground)
                }
                
                
                VStack {
                    ScrollView {
                        Text("Hello, World! Now we are talking about something which we wish would be completely understandable.")
                            
                            .font(.system(size: 40))
                            .padding(10)
                    }
                    HStack {
                        
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 30))
                        }
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "keyboard")
                                .font(.system(size: 30))
                        }
                        Button {
                            print("Edit button was tapped")
                        } label: {
                            Image(systemName: "mic.circle.fill")
                                .font(.system(size: 60))
                            //                            .padding()
                        }
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 30))
                        }
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 30))
                        }
//
                       
                    }.foregroundColor(Color(.systemTeal))
                    .padding(20)
                    
                    
                }
            }
        }
        .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
            
        }
    }
}

struct LiveTextView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTextView()
    }
}
