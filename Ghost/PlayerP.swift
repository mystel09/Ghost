//
//  PlayerP.swift
//  Ghost
//
//  Created by TovaM on 7/15/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class PlayerP: PFUser {
    @NSManaged var name:String
    @NSManaged var color: Int
    @NSManaged var points: Int


    init(name:String, playerColor: Int) {
        
        super.init()
        
        self.name = name
        self.color = playerColor
        self.points = 0

    }
    override init () { //boilerplate code that needs to be added for parse
        super.init()
    }
    
    override class func initialize() { //boilerplate
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}
