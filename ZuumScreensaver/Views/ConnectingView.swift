//
//  ConnectingView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/3/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import SwiftUI


struct ConnectingView: View {
    var body: some View {
        VStack {
            Text("Join a Meeting")
                .foregroundColor(.black)
                .frame(width: 200, height: 20, alignment: .center)
                .padding(.bottom, 40)
                .font(Font.system(.headline))

            Text("Connecting…")
                .foregroundColor(.black)
                .frame(width: 200, height: 20, alignment: .center)
                .padding(.bottom, 10)
            
            ProgressIndicator() {
                $0.controlTint = .graphiteControlTint
                $0.isIndeterminate = true
                $0.style = .spinning
                $0.startAnimation(nil)
            }
            .frame(width: 200, height: 20, alignment: .center)
        }
    }
}


struct ConnectingView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectingView()
    }
}
