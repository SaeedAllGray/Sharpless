//
//  SoundAnalysis.swift
//  Sharpless
//
//  Created by Media Davarkhah on 9/3/1400 AP.
//

import Foundation
import SoundAnalysis

class SoundResultsObserver: NSObject, SNResultsObserving {

    func request(_ request: SNRequest, didProduce result: SNResult) { // Mark 1

        guard let result = result as? SNClassificationResult else  { return } // Mark 2

        guard let classification = result.classifications.first else { return } // Mark 3

        let timeInSeconds = result.timeRange.start.seconds // Mark 4

        let formattedTime = String(format: "%.2f", timeInSeconds)
        print("Analysis result for audio at time: \(formattedTime)")

        let confidence = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", confidence)

        print("\(classification.identifier): \(percentString) confidence.\n") // Mark 5
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
