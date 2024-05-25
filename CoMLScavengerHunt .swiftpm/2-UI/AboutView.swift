//
//  AboutView.swift
//  coreML-starter
//
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        ZStack {
            // background color
            Color(red: 181/255, green: 235/255, blue: 255/255)
                .edgesIgnoringSafeArea(.top)
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Text("Add some info about who created the app!")
                        .padding()
                    
                    Spacer() // fill vertical space
                }
                
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(25)
            .shadow(radius: 5)
            .padding()
        }
    }
}

#Preview {
    AboutView()
}
