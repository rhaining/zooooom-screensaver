//
//  OptionsView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/15/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//
import SwiftUI

struct OptionsView: View {
    
    @State var selectedVideoSetIndex: Int

    let save: ((Int) -> Void)
    
    var body: some View {
        VStack {
            Text("Which set of videos do you want to see in the screensaver?")
                .padding(10)
            
            Form {
                Picker("", selection: $selectedVideoSetIndex) {
                    ForEach(0..<VideoSet.allCases.count) {
                        Text(VideoSet.allCases[$0].rawValue)
                            .tag($0)
                    }
                }
            }
            .padding(10)
            
            Button(action: {
                self.save(self.selectedVideoSetIndex)
            }) {
                Text("Close")
            }
            .padding(10)
            
            
        }.frame(maxWidth: 250)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(selectedVideoSetIndex: 0) { (videoSetIndex) in
            
        }
    }
}


