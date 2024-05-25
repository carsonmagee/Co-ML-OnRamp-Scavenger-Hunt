import CoreML

struct PlaygroundsModel {
    let model: MLModel
    
    // If for whatever reason the model file can't be found, app will crash
    // upon load
    init(_ filename: String) throws {        
        // get our model file
        let modelURL = URL(fileReferenceLiteralResourceName: filename)
        
        // initialize our machine learning model
        let compiledModelURL = try! MLModel.compileModel(at: modelURL)
        self.model = try! MLModel(contentsOf: compiledModelURL)
    }
}
