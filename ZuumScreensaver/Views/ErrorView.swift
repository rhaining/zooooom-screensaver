//
//  ErrorView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/8/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(.white)
            .background(Color(red: 14/255.0, green: 115/255.0, blue: 237/255.0))
            .cornerRadius(10)
    }
}

struct ErrorView: View {
    var errorText: String?
    
    var body: some View {
        VStack {
            Spacer()
            Text("You are unable to connect to Zooooom. Please check your network connection and try again.")
                .foregroundColor(.black)
                .font(.system(size: 18))
                .padding(30)
            
            Button("Connect", action: {})
                .buttonStyle(BlueButtonStyle())
            
            Spacer(minLength: 200)
            
            Text(errorText ?? "")
                .foregroundColor(.black)
                .font(.system(.footnote))
            Spacer()
        }.frame(width: 410)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
