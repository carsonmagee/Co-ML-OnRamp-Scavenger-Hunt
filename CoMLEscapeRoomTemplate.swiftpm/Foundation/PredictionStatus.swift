//
//  PredictionStatus.swift
//

import Foundation
import SwiftUI
import Vision

// This file helps convert the raw output from a model prediction into Published variables to update views
// Core functionality: DO NOT CHANGE

typealias LivePredictionResults = [String: (basicValue: Double, displayValue: String)]

class PredictionStatus: ObservableObject {
    @Published var topLabel = ""
    @Published var topConfidence = ""
    
    // Live prediction results
    @Published var livePrediction: LivePredictionResults = [:]
    
    func setLivePrediction(with results: LivePredictionResults, label: String, confidence: String) {
        livePrediction = results
        topLabel = label
        topConfidence = confidence
    }
}
