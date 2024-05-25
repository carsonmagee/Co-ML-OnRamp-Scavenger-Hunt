//
//  RoundedRectButtonStyle.swift
//  coreML-starter
//
//  
//

import SwiftUI
import Foundation

struct MyButtonStyle: ButtonStyle {
    var buttonColor = Color.blue
    var textColor = Color.white
    var fullWidth = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if (fullWidth) {
                Spacer()
            }
            configuration.label.foregroundColor(textColor)
            if (fullWidth) {
                Spacer()
            }
        }
        .padding()
        .background(configuration.isPressed ? buttonColor.opacity(0.7) : buttonColor)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack {
        Button("Button", systemImage: "arrow.up") {
            // do nothing
        }
        .buttonStyle(MyButtonStyle())
    }
}
