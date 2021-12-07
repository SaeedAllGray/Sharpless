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

    var body: some View {
        
        VStack {
            if(eventViewModel.loadState == .loading) {
                VStack {
                        ProgressView()
                        
                    }
            } else {
                List(Array(zip(eventViewModel.eventList, eventViewModel.patternList)) ,id: \.0) { item in
                    NavigationLink(destination: SetVibrationView(event: item.0)) {
                    
                    HStack {
                        Text(item.0)
                        Spacer()
                        
                      PatternView(pattern: item.1)
                       
                    }
                }
                
                
                
            }
            .listStyle(InsetGroupedListStyle())
            }
        }.onAppear(perform: {
            eventViewModel.setEvents()
        })
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        
        }
        .accentColor(.teal)
        .navigationTitle("Events")
        
        
        
        
        
    }
}

@available(iOS 15.0, *)
struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
