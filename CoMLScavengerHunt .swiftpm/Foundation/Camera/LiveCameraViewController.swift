//
//  LiveCaptureSessionViewController.swift
//  coreML-starter
//

import UIKit
import SwiftUI

// This file helps render the camera stream to the app's screen
// Core functionality: DO NOT CHANGE

struct LiveCameraRepresentable: UIViewControllerRepresentable {
    
    let camera: Camera
    let myClassifier: MyClassifier

    func makeUIViewController(context: Context) -> LiveCameraViewController {
        let vc = LiveCameraViewController(camera: camera)
        return vc
    }
    
    func updateUIViewController(_ cameraViewController: LiveCameraViewController, context: Context) {
        // no-op
    }
}


final class LiveCameraViewController: UIViewController {
    let camera: Camera
    private var liveVideoFeedDisplayLayer = CALayer()
    
    init(camera: Camera) {
        self.camera = camera
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveVideoFeedDisplayLayer = view.layer
        if let previewLayer = camera.previewLayer {
            liveVideoFeedDisplayLayer.insertSublayer(previewLayer, at: 0)
        } else {
            print("Error: Unable to start up model preview layer on camera")
        }
    }
    
}
