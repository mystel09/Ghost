//
//  Player.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name:String
    var playerColor:UIColor
    
    init(name:String, playerColor: UIColor) {
        self.name = name
        self.playerColor = playerColor
    }
    
}
