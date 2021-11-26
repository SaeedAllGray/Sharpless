//
//  SoundClassifier.swift
//  Sharpless
//
//  Created by Media Davarkhah on 8/15/1400 AP.
//

import Foundation
import SoundAnalysis
struct SoundClassifier {
    func getListOFRecognizedSounds() throws ->[String]? {
        if #available(iOS 15.0, *) {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            return request.knownClassifications
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
}
