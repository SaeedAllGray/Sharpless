//
//  EventListView.swift
//  Sharpless
//
//  Created by saeed on 12/2/21.
//

import SwiftUI


@available(iOS 15.0, *)
struct EventListView: View {
    @ObservedObject var eventViewModel = EventViewModel()
    @State private var showingSetVibrationView = false
    
    var body: some View {
        
        VStack {
            if(eventViewModel.loadState == .loading) {
                VStack {
                    ProgressView()
                    
                }
            } else if eventViewModel.loadState == .notLoaded {
                Text("Not Connected.")
            }
            else {
                List(Array(zip(eventViewModel.eventList, eventViewModel.patternList)) ,id: \.0) { item in
                    NavigationLink(destination: SetVibrationView(event: item.0.rawValue)) {
                        
                        HStack {
                            Text(item.0.rawValue)
                            Spacer()
                            
                            PatternView(pattern: item.1)
                            
                        }
                    }
                    
                    
                    
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .accentColor(.teal)
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            print("SEET EVVENTS")
            eventViewModel.setEvents()
        })
        
            
        
        
        
        
        
    }
}

@available(iOS 15.0, *)
struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
