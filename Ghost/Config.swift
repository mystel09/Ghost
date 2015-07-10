//
//  Config.swift
//  Ghost
//
//  Created by TovaM on 7/7/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let TileMargin: CGFloat = 20.0
let FontHUD = UIFont(name:"comic andy", size: 62.0)!
let FontHUDBig = UIFont(name:"comic andy", size:120.0)!
let SoundWrong = "wrong.m4a"
let AudioEffectFiles = [SoundWrong]
let timeToSolve : Int = 10


//Random number generator
func randomNumber(#minX:UInt32, #maxX:UInt32) -> Int {
    let result = (arc4random() % (maxX - minX + 1)) + minX
    return Int(result)
}