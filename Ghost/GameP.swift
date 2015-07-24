//
//  GameP.swift
//  Ghost
//
//  Created by TovaM on 7/17/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class GameP: PFObject, PFSubclassing {
   
    var playersP:[PlayerP] = []
   @NSManaged var MinWordSize: Int
   @NSManaged var IndexOfCurrentPlayer: Int
   @NSManaged var CurrentWord: [String]!
   @NSManaged var Color: [Int]
   
    func goToNextPlayer() {
        self.IndexOfCurrentPlayer = (self.IndexOfCurrentPlayer+1) % self.playersP.count
    }
    
    func getCurrentPlayer() -> PlayerP {
        return playersP[IndexOfCurrentPlayer]
    }
    func goToLastPlayer() {
        if self.IndexOfCurrentPlayer == 0 {
            self.IndexOfCurrentPlayer = self.playersP.count-1
        }
        else{
            self.IndexOfCurrentPlayer = self.IndexOfCurrentPlayer-1
        }
    }
    func resetRound() {
        IndexOfCurrentPlayer = (self.IndexOfCurrentPlayer+1) % self.playersP.count
        CurrentWord = [String]()
        Color = []
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
    static func parseClassName() -> String {
        return "Game" //server name, not the classname here
    }
    
}
