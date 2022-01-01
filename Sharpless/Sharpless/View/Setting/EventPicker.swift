//
//  EventPicker.swift
//  Sharpless
//
//  Created by saeed on 12/15/21.
//

import SwiftUI
import SoundAnalysis

@available(iOS 15.0, *)
struct EventPicker: View {
    @Binding var event: String
    var eventList: [String] = {
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1)
            return request.knownClassifications
        } catch {
            
        }
        return []
    }()
    var body: some View {
        Picker(selection: $event, label: Spacer()) {
          // 3
          ForEach(eventList, id: \.self) {
            Text($0)
          }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

@available(iOS 15.0, *)
struct EventPicker_Previews: PreviewProvider {
    static var previews: some View {
        EventPicker(event: .constant("My Name"))
    }
}
