//
//  EventViewModel.swift
//  Sharpless
//
//  Created by saeed on 12/2/21.
//

import SwiftUI

final class EventViewModel: ObservableObject {
    @Published var eventList: [Events] = events
    @Published var patternList: [Pattern] = [Pattern](repeating: Pattern(string: ""), count: events.count)
    @Published var loadState = LoadState.notLoaded
    
    
    func setEvents() {
        let url = URL(string: "http://192.168.1.134/getdata")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            print("|||||||||||||||||||||||||||||")
            guard let data = data else { return }
            print("1233333333333")
            
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                self.loadState = .loading
                //                self.patternList = []
                //                self.eventList = []
                var resultString = ""
                resultString = String(data: data, encoding: .utf8)!
                
                
                let resultList = resultString.components(separatedBy: "#")
                
                for result in resultList {
                    print(result)
                    if(result.count > 0) {
                        for (index, element) in self.eventList.enumerated() {
                            
                            
                            
                            let indexOfColon = result.firstIndex(of: ":")!
                            let startPattern = result.index(after: indexOfColon)
                            let event = result.substring(to: indexOfColon)
                            print(element.rawValue + "----VS----" + event)
                            if(event == element.rawValue) {
                                //                                print(result.substring(from: startPattern))
                                let pattern = Pattern.init(string: result.substring(from: startPattern))
                                print(pattern)
                                print(index)
                                self.patternList[index] = pattern
                            }
                        }
                    }
                }
                print(self.patternList)
                self.loadState = .loaded
            }
        }
        
        task.resume()
        
        
    }
}
