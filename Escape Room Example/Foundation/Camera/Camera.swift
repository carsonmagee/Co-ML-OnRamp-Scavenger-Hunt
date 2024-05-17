//
//  Camera.swift
//  coreML-starter-checklist
//

import Foundation
import Vision
import AVFoundation
import UIKit

// This file runs the camera
// Core functionality: DO NOT CHANGE

final class Camera: NSObject, ObservableObject {
    private var myClassifier: MyClassifier?
    private var model: VNCoreMLModel?
    
    private(set) var rawVideoDimensions: CGSize = .zero
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let videoOutputQueue = DispatchQueue(label: "VideoOutput")
    
    private(set) var previewLayer: AVCaptureVideoPreviewLayer?
        
    override init() {
        super.init()
    }
    
    
    // initalizes model for use with camera
    func connectModel(myClassifier: MyClassifier) {
        // only update if the model changes
        if myClassifier.mlModel.model != self.myClassifier?.mlModel.model {
            self.myClassifier = myClassifier
            self.model = try? VNCoreMLModel(for: myClassifier.mlModel.model)
        }
    }
    
    // starts / unpauses the camera
    func startSession() throws {
        Task(priority: .userInitiated) {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    // pauses the camera
    func stopSession() throws {
        if self.session.isRunning {
            self.session.stopRunning()
        }
    }
    
    // live capture setup must be run before we start the camera
    func setUpLiveCapture() {
        let videoDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video, position: .back
        ).devices.first
        guard let videoDevice = videoDevice else { return }
        
        var deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        guard session.canAddInput(deviceInput) else {
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        
        guard session.canAddOutput(videoOutput) else {
            session.commitConfiguration()
            return
        }
        session.addOutput(videoOutput)
        
        let pixelBufferFormatKey = Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: pixelBufferFormatKey
        ]
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        videoOutput.connection(with: .video)?.isEnabled = true // Always process the frames
        
        do {
            try videoDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(
                videoDevice.activeFormat.formatDescription
            )
            rawVideoDimensions.width = CGFloat(dimensions.width)
            rawVideoDimensions.height = CGFloat(dimensions.height)
            videoDevice.unlockForConfiguration()
        } catch {
        }
        
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.contentsGravity = .resizeAspect
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.connection?.videoOrientation = videoOrientationFromCurrentDeviceOrientation()
        previewLayer?.frame = UIScreen.main.bounds // fill screen
    }
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // runs camera input on our ML model
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        
        guard
            let model = model else {
                return
            }
        
        // process image and resize to scale with training image dimensions
        let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let request = VNCoreMLRequest(model: model) { request, error in
            let observations = request.results as? [VNClassificationObservation] ?? []
            
            let predictionResultsMap = observations.map {
                (
                    $0.identifier,
                    (basicValue: Double($0.confidence), displayValue: String(format: "%.0f%%", $0.confidence * 100))
                )
            }
            
            let topResult = observations.first
            let compiledResults = Dictionary(uniqueKeysWithValues: predictionResultsMap)
            
            DispatchQueue.main.async {
                self.myClassifier?.onPrediction(results: compiledResults, label: topResult!.identifier, confidence: String(format: "%.0f%%", topResult!.confidence * 100))
            }
        } // request
        
        request.imageCropAndScaleOption = .centerCrop
        
        try? VNImageRequestHandler(
            cvPixelBuffer: cvImageBuffer,
            orientation: exifOrientation(),
            options: [:]
        ).perform([request])
    }
}

extension Camera {
    
    // Helper for device orientation
    func videoOrientationFromCurrentDeviceOrientation() -> AVCaptureVideoOrientation {
                    return AVCaptureVideoOrientation.landscapeRight
        switch
        UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
       // case .portrait:
       //     return AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
       // case .portraitUpsideDown:
       // return AVCaptureVideoOrientation.portraitUpsideDown
        default:
            // might not ever happen
            return AVCaptureVideoOrientation.landscapeLeft
        }
    }

    // Helper for device orientation
    func exifOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
            
        case UIDeviceOrientation.portraitUpsideDown:
            // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:
            // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:
            // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:
            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
