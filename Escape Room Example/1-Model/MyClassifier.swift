//
//  MyClassifier.swift
//  coreML-starter-checklist
//

import Foundation
import CoreML

struct ClassifierLabel: Hashable {
    var displayName: String
    var emoji: String
    var count: Int // this is our custom property for the packing checklist
}

extension ClassifierLabel {
    /// Default label. If you see this appear on screen, something has gone wrong
    static var unknown = ClassifierLabel(displayName: "Unknown", emoji: "❌", count: 0)
}

class MyClassifier: ObservableObject {
    @Published var predictionStatus = PredictionStatus() // DO NOT CHANGE
    @Published var predictedLabel: ClassifierLabel = ClassifierLabel.unknown // DO NOT CHANGE
    
    // replace Clothing with the name of your model file
    let mlModel: PlaygroundsModel
    
    init() {
        // replace Clothing with the name of your model file
        self.mlModel = try! PlaygroundsModel("Clothing.mlmodel")
    }

    /*
     * Put your classifier labels and custom properties here
     * The string key MUST match the model's label name, but the display name can be different
     */
    @Published var labels = [
        "Socks": ClassifierLabel(displayName: "Socks", emoji: "🧦", count: 0),
        "Pants": ClassifierLabel(displayName: "Pants", emoji: "👖", count: 0),
        "Shirts": ClassifierLabel(displayName: "Shirts", emoji: "🩳", count: 0)
    ]
    
    // DO NOT CHANGE
    func onPrediction(results: LivePredictionResults, label: String, confidence: String) {
        predictionStatus.setLivePrediction(with: results, label: label, confidence: confidence)
        predictedLabel = labels[predictionStatus.topLabel] ?? ClassifierLabel.unknown
    }
}
