//
//  PlayerP.swift
//  Ghost
//
//  Created by TovaM on 7/15/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit


class PlayerP: GKLocalPlayer {
     var name:String
     var color: UIColor
     var points: Int
    var extra: String
    override var playerID: String { return extra }
    
    init(name:String, playerColor: UIColor, playerID: String) {
        
        self.name = name
        self.color = playerColor
        self.points = 0
        extra = playerID
        super.init()
    }
  }
