//
//  ToolbarView.swift
//  ZuumScreensaver
//
//  Created by Robert Tolar Haining on 4/6/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import SwiftUI

struct ToolbarValues {
    static let white = Color(white: 215/255.0)
    static let red = Color(red: 208/255.0, green: 60/255.0, blue: 60/255.0)
    static let grey = Color(white: 30/255.0)
    
    static let font = Font.system(size: 11)
    static let emojiFont = Font.system(size: 15)
}

struct ToolbarItem: View {
    let title: String
    let emoji: String
    
    var body: some View {
        VStack {
            Text(emoji)
                .font(ToolbarValues.emojiFont)
                .padding(6)
            Text(title)
                .font(ToolbarValues.font)
                .foregroundColor(ToolbarValues.white)
        }
    }
}

struct NumberedToolbarItem: View {
    @Binding var count: Int
    let title: String
    let emoji: String

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(emoji)
                    .font(ToolbarValues.emojiFont)
                
                Text(String(count))
                    .font(ToolbarValues.font)
                    .foregroundColor(ToolbarValues.white)
            }
            .padding(6)

            
            Text(title)
                .font(ToolbarValues.font)
                .foregroundColor(ToolbarValues.white)
        }
    }
}

struct ToolbarView: View {    
    @ObservedObject var blockbuster: Blockbuster

    var body: some View {
        HStack {
            HStack {
                ToolbarItem(title: "Mute", emoji: "🎤")
                ToolbarItem(title: "Stop Video", emoji: "🎥")
            }
            
            Spacer()
            
            HStack {
                ToolbarItem(title: "Invite",  emoji: "👩‍💻")
                NumberedToolbarItem(count: $blockbuster.currentNumberOfVideos,
                                    title: "Manage Participants",
                                    emoji: "👩‍👩‍👦‍👦")
                ToolbarItem(title: "Share Screen", emoji: "💻")
                ToolbarItem(title: "Chat", emoji: "💬")
                ToolbarItem(title: "Record", emoji: "🤳")
                ToolbarItem(title: "Reactions", emoji: "😬")
            }
            
            Spacer()

            Text("End Meeting")
                .font(ToolbarValues.font)
                .foregroundColor(ToolbarValues.red)
        }
        .padding()
        .background(ToolbarValues.grey)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView(blockbuster: Blockbuster())
    }
}

