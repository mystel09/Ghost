//
//  PlayerP.swift
//  Ghost
//
//  Created by TovaM on 7/15/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit


class PlayerP: GKLocalPlayer, NSCoding {
     var name:String
     var color: UIColor
     var points: Int
     var extra: String
     var wasChallenged: Bool = false

    override var playerID: String { return extra }
    
    init(name:String, playerColor: UIColor, playerID: String) {
        
        self.name = name
        self.color = playerColor
        self.points = 0
        extra = playerID
        super.init()
    }
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as! String!
        self.color = decoder.decodeObjectForKey("color") as! UIColor!
        self.points = decoder.decodeIntegerForKey("points")
        self.extra = decoder.decodeObjectForKey("extra") as! String!
        self.wasChallenged = decoder.decodeBoolForKey("wasChallenged")
        super.init()

    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.color, forKey: "color")
        coder.encodeInt(Int32(self.points), forKey: "points")
        coder.encodeObject(self.extra, forKey: "extra")
        coder.encodeBool(self.wasChallenged, forKey: "wasChallenged")
    }

  }
