//
//  ChallengeView.swift
//  CoreML Starter Checklist
//
//  Created by Richard Lombardo on 2/2/24.
//

import SwiftUI

struct ChallengeTileView: View {
    
    @EnvironmentObject var myClassifier: MyClassifier
    @State private var hintAlert = false
    @State private var checkAlert = false
    var myChallenge: Challenge
    
    //@State var isLockClosed = true
    let ultraLightConfiguration = UIImage.SymbolConfiguration(weight: .ultraLight)

    
    var body: some View {
        //let labelData = myClassifier.predictedLabel
        
        VStack(alignment: .center) {
            
            Text(myChallenge.challengeName)
                .font(.title.bold())
                .foregroundStyle(Color(red: 49/255, green: 54/255, blue: 56/255))
                .padding()
            
           // Spacer()
            if myChallenge.solved {
                Image(systemName: "key.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.green)
                    .rotationEffect(.degrees(45))
                    
            } else {

                Image(systemName: "key")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
                    .rotationEffect(.degrees(45))
                    .fontWeight(.ultraLight)
            }
            Spacer()
            
        }
    }
}


#Preview {
    ChallengeTileView(myChallenge: Challenge(challengeName: "Name", challengeDetails: "Details", solved: false, hint: "Hint", classifier: "Socks"))
        .environmentObject(MyClassifier())
}
