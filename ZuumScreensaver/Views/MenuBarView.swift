//
//  MenuBarView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/7/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var blockbuster: Blockbuster

    var body: some View {
        HStack {
            HStack {
                Text("ℹ️")
                Text("🔒")
            }
            
            Spacer()
            
            Text(blockbuster.upgradeMessage ?? "")
                .font(.system(size: 13))
                .foregroundColor(ToolbarValues.white)

            
            Spacer()
            
            HStack {
                Text("Exit Full Screen")
                    .font(ToolbarValues.font)
                    .foregroundColor(ToolbarValues.white)
            }
        }
        .padding()

    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(blockbuster: Blockbuster())
    }
}
