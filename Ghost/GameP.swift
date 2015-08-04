//
//  GameP.swift
//  Ghost
//
//  Created by TovaM on 7/17/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit

class GameP: NSObject, NSCoding{
   
    var playersP:[PlayerP] = []
    var MinWordSize: Int = 4
    var CurrentWord: [String] = []
    var Color: [UIColor] = []
    var GKTurnTimeoutNone: NSTimeInterval = 0.0
    var gameStarted: Bool = false
    var lastPlayer: PlayerP?

    // MARK: NSCoding
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.playersP = (decoder.decodeObjectForKey("playersP") as! [PlayerP]?)!
        self.MinWordSize = (decoder.decodeIntegerForKey("MinWordSize"))
        //self.IndexOfCurrentPlayer = decoder.decodeIntegerForKey("IndexOfCurrentPlayer")
        self.CurrentWord = decoder.decodeObjectForKey("CurrentWord") as! [String]!
        self.Color = decoder.decodeObjectForKey("Color") as! [UIColor]!
        self.gameStarted = decoder.decodeBoolForKey("gameStarted")
        self.lastPlayer = decoder.decodeObjectForKey("lastPlayer") as! PlayerP!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.playersP, forKey: "playersP")
        coder.encodeInt(Int32(self.MinWordSize), forKey: "MinWordSize")
        //coder.encodeInt(Int32(self.IndexOfCurrentPlayer), forKey: "IndexOfCurrentPlayer")
        coder.encodeObject(self.CurrentWord, forKey: "CurrentWord")
        coder.encodeObject(self.Color, forKey: "Color")
        coder.encodeBool(self.gameStarted, forKey: "gameStarted")
        coder.encodeObject(self.lastPlayer,forKey: "lastPlayer")
    }
}

