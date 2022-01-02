//
//  SoundAnalysis.swift
//  Sharpless
//
//  Created by Media Davarkhah on 9/3/1400 AP.
//

import Foundation
import SoundAnalysis
import Speech
class SoundResultsObserver: NSObject, SNResultsObserving {

    func request(_ request: SNRequest, didProduce result: SNResult) {

        guard let result = result as? SNClassificationResult else  { return }

        guard let classification = result.classifications.first else { return }

        //let timeInSeconds = result.timeRange.start.seconds


        let confidence = classification.confidence * 100.0
      
        
        if confidence > 60 {
            if #available(iOS 15.0, *) {
                let date = Date()
                let formattedTime = date.formatted(date: .complete, time: .complete)
                print("Analysis result for audio at time: \(formattedTime)")
                let sound = recognizedSound(name: classification.identifier, time: formattedTime)
                LiveTextViewModel.shared.soundsHistory.append(sound)
                UserDefaults.standard.domainSchemas.append(sound)
                
            } else {
            // Fallback on earlier versions
            }
        }
        
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
