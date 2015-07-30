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


    init(name:String, playerColor: UIColor) {
        
        self.name = name
        self.color = playerColor
        self.points = 0
        super.init()
    }
  }
