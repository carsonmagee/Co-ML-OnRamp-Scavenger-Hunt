//
//  coreML-starter.swift
//

import SwiftUI

// This file sets up the main views and objects our app needs to run
// Core functionality: DO NOT CHANGE

@main
struct coreML_starterApp: App {
    
    @ObservedObject private var myClassifier = MyClassifier()
    private let camera = Camera()
    
    var body: some Scene {
        WindowGroup {
           contentView
        }
    }
    
    var contentView: some View {
        NavigationView {
            GameView()
        }
        .environmentObject(myClassifier)
        .environmentObject(camera)
        .navigationViewStyle(.stack)
        .onAppear {
            camera.setUpLiveCapture()
        }
    }
}
