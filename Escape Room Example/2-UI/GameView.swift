//
//  LaunchView.swift
//  CoreML Starter Checklist
//
//  Created by Richard Lombardo on 2/12/24.
//


import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var myClassifier: MyClassifier
    @State var myChallenges = initialChallenges
    
    var body: some View {
        VStack {
            
            VStack {

                // TODO: Replace app title
                Text("Escape Room")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 89/255, green: 87/255, blue: 81/255))
                
                Divider().frame(maxWidth: 300)
                
                // info
                // TODO: Replace with description of your app
                VStack(spacing: 20) {
                    Text("This app uses machine learning to create a unique type of scavenger hunt.")
                    .foregroundColor(Color(red: 89/255, green: 87/255, blue: 81/255))

                }
                .padding()
                .multilineTextAlignment(.center)
            }
            .frame(width: 680)
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .shadow(radius: 5)
            
            HStack {
                ForEach($myChallenges, id: \.challengeName) { $challenge in
                    NavigationLink {
                        ClassificationView(myChallenge: $challenge)
                    } label: {
                        ZStack {
                            ChallengeTileView(myChallenge: challenge)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(radius: 5)
                }
            }
            .padding()
            
            // about page
            NavigationLink(destination: AboutView()){
                Text("Credits")
            }
            .padding()
            
            
            
        }// VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color(red: 181/255, green: 235/255, blue: 255/255))
        .background(Image("lockbkgd")
            .resizable()
            .scaledToFill())
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}


#Preview {
    GameView()
        .environmentObject(MyClassifier())
        //.previewDevice(PreviewDevice(rawValue: "iPad mini"))
}
