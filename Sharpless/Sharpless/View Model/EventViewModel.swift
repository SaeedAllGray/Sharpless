//
//  EventViewModel.swift
//  Sharpless
//
//  Created by saeed on 12/2/21.
//

import SwiftUI

final class EventViewModel: ObservableObject {
    @Published var eventList = [String]()
    @Published var patternList = [Pattern]()
    @Published var loadState = LoadState.notLoaded
    
    
    func setEvents() {
        loadState = .loading
        let url = URL(string: "http://192.168.1.134/getdata")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                self.patternList = []
                self.eventList = []
                var resultString = ""
                resultString = String(data: data, encoding: .utf8)!
                let resultList = resultString.components(separatedBy: "#")
                for result in resultList {
                    if(result.count > 0) {
                        let indexOfColon = result.firstIndex(of: ":")!
                        let startPattern = result.index(after: indexOfColon)
                        let event = result.substring(to: indexOfColon)
                        print(result.substring(from: startPattern))
                        let pattern = Pattern.init(string: result.substring(from: startPattern))
                        self.eventList.append(event)
                        self.patternList.append(pattern)
                        
                        
                        
                        
                    }
                }
                print(self.eventList)
                print(self.patternList)
                self.loadState = .loaded
            }
        }
        
        task.resume()
        
        
    }
}
