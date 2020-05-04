//
//  Dice.swift
//  Zuum
//
//  Created by Robert Tolar Haining on 4/6/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation

enum Dice: CaseIterable {
    case add, remove, stay, pause, loseConnection
    
    static func roll() -> Dice {
        let number = Int.random(in: 0..<100)
        switch number {
            case 0..<35:
                return .add
            
            case 35..<40:
                return .remove
            
            case 40..<50:
                return .pause
            
            case 50..<55:
                return .loseConnection
            
            default:
                return .stay
        }
    }
}
