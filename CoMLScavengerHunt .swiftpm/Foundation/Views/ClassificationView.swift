//
//  ClassificationView.swift
//  coreML-starter
//

import SwiftUI

// This file sets up the main camera view

struct ClassificationView: View {
    
    @EnvironmentObject var myClassifier: MyClassifier
    @EnvironmentObject var camera: Camera
    @State private var paused: Bool = false
    @Binding var myChallenge: Challenge

    var body: some View {
        HStack {
            
            // camera rendering DO NOT CHANGE
            LiveCameraRepresentable(camera: camera, myClassifier: myClassifier)
                .scaleEffect(0.6)
                .offset(x: -50)
            
            // center pause button on camera view
            VStack {
                
                //side bar to show prediction results
                ChallengeView(
                    predictedLabel: myClassifier.predictedLabel,
                    currentChallenge: $myChallenge,
                    pause: pauseCamera,
                    play: startCamera
                )
                    //.frame(width: 250)
                    .padding(.vertical)
                    .ignoresSafeArea()
                    .padding()

            }
            .background(Color(red: 232/255, green: 233/255, blue: 235/255))
            .cornerRadius(10)
            .shadow(radius: 25)
            .padding()
        }
        .background(Color(red: 240/255, green: 101/255, blue: 67/255))
        .ignoresSafeArea() // full screen
        .onAppear {
            // first connect model
            camera.connectModel(myClassifier: myClassifier)
            
            // now start camera session
            startCamera()
        }
        .onDisappear {
            // stop camera session
            pauseCamera()
        }

    }
    
    func pauseCamera() {
        do {
            try camera.stopSession()
            paused = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startCamera() {
        do {
            try camera.startSession()
            paused = false
        } catch {
            print(error.localizedDescription)
        }
    }
   
//    func winChallenge() {
//        myChallenge.unlock()
//    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView(myChallenge: .constant(Challenge(challengeName: "Name", challengeDetails: "Details", solved: false, hint: "Hint", classifier: "Socks")))
            .environmentObject(MyClassifier())
            .environmentObject(Camera())
    }
}
