//
//  Challenges.swift
//  CoreML Starter Checklist
//
//  Created by Richard Lombardo on 2/2/24.
//

import Foundation
import CoreML

struct Challenge: Hashable {
    var challengeName: String
    var challengeDetails: String
    var solved: Bool = false
    var hint: String
    var classifier: String
    var guesses: Int = 0
    
    mutating func solve() {
        solved = true
    }
}


//class MyChallenges: ObservableObject {

let initialChallenges = [
    Challenge(
        challengeName: "Challenge 1",
        challengeDetails: "I come as a pair but I’m not binoculars. I’m sometimes a tube but I don’t contain toothpaste.",
        hint: "I’m something you wear but I’m not jeans.",
        classifier: "Socks"
    ),
    Challenge(
        challengeName: "Challenge 2",
        challengeDetails: "What can be a trunks but is not an elephant?",
        hint: "Usually worn when it's warm.",
        classifier: "Shirts"
    ),
    Challenge(
        challengeName: "Challenge 3",
        challengeDetails: "We have legs but no flesh or bone, we have different colors of our own. What are we?",
        hint: "Made of different materials like denim, corduroy, and linen.",
        classifier: "Pants"
    )
]
