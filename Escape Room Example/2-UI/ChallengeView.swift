//
//  PredictionResultView.swift
//  coreML-starter
//

import SwiftUI

struct ChallengeView: View {
    let predictedLabel: ClassifierLabel
    @State private var showHintAlert = false
    @State private var showGuessAlert = false
    @State private var showButton = true

    
    @Binding var currentChallenge: Challenge

    /// pause camera & classification
    let pause: () -> Void
    /// play camera & classification
    let play: () -> Void

    var body: some View {
        VStack {
            
            if currentChallenge.solved {
                Text("🏆 Solved")
                    .font(.title.bold())
                    .foregroundStyle(.green)
            }
            
            Text(currentChallenge.challengeName)
                .font(.largeTitle.bold())
                .foregroundStyle(Color(red: 49/255, green: 54/255, blue: 56/255))
                .padding()
                .onLongPressGesture {
                    // Debug code
                    //correctAnswer = true
                    pause()
                    showGuessAlert = true
                    currentChallenge.solve()
                }
            
            Text(currentChallenge.challengeDetails)
                .font(.title2)
                .foregroundStyle(Color(red: 49/255, green: 54/255, blue: 56/255))
                .padding()
            
            Text("Number of guesses: \(currentChallenge.guesses)")
                     .foregroundColor(Color(red: 89/255, green: 87/255, blue: 81/255))
            
            if currentChallenge.solved {
                Text("Correct answer: \(currentChallenge.classifier)")
                    .font(.caption.bold())
                    .foregroundColor(Color(red: 89/255, green: 87/255, blue: 81/255))
            }
                
                Button("Guess") {
                    if predictedLabel.displayName != ClassifierLabel.unknown.displayName {
                        if predictedLabel.displayName == currentChallenge.classifier {
                           currentChallenge.solve()
                        }
                    }
                    pause()
                    showGuessAlert = true
                    currentChallenge.guesses += 1
                }
                .buttonStyle(MyButtonStyle())
                .padding(10)
                .alert(isPresented: $showGuessAlert) {
                    
                    if currentChallenge.solved {
                        Alert(
                            title: Text("Congratulations"),
                            message: Text("You guessed correctly!"),
                            dismissButton: .default(Text("OK")) {
                                //showButton = false
                                currentChallenge.solve()
                            }
                        )
                    } else {
                        Alert(
                            title: Text("Wrong Answer"),
                            message: Text("Sorry, please try again."),
                            dismissButton: .default(Text("OK")) {
                                play()
                            }
                        )
                    }
                }
                
                
                Button("Hint") {
                    showHintAlert = true
                    pause()
                }
                .padding()
                .alert(isPresented: $showHintAlert) {
                    Alert(
                        title: Text("\(currentChallenge.challengeName) Hint"),
                        message: Text(currentChallenge.hint),
                        dismissButton: .default(Text("Cancel")) {
                            play()
                        }
                    )
                }
            
        }
        .frame(maxWidth: 250)
    }
}


#Preview {
    ChallengeView(
        predictedLabel: .unknown,
        currentChallenge: .constant(Challenge(challengeName: "Name", challengeDetails: "Details", solved: false, hint: "Hint", classifier: "Socks")),
        pause: {
            // do nothing
        },
        play: {
        // do nothing
    })
}
