//
//  SetPatternViewModel.swift
//  Sharpless
//
//  Created by saeed on 12/2/21.
//

import SwiftUI

final class SetPatternViewModel: ObservableObject {
    @Published var pattern: Pattern = Pattern(string: "")
    
    func testPattern() {
        let url = URL(string: "http://192.168.1.134/testpattern?pattern=\(self.pattern.getString())")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    func savePattern(event: String, pattern: Pattern) {
        let url = URL(string: "http://192.168.1.134/setpattern?event=\(event)&pattern=\(self.pattern.getString())")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    func shouldActiveSaveButton() -> Bool {
        return pattern.vibrationList.count == 5
    }
    func clearPattern() {
        pattern.vibrationList = []
    }
}
