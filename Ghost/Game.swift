//
//  Game.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class Game: NSObject {
    var players:[Player] = []
    var minWordSize: Int = 4
    var indexOfCurrentPlayer = 0
    var currentWord = [String]()
    
    func goToNextPlayer() {
        self.indexOfCurrentPlayer = (self.indexOfCurrentPlayer+1) % self.players.count
    }

    func getCurrentPlayer() -> Player {
        return players[indexOfCurrentPlayer]
    }
    func resetRound() {
         indexOfCurrentPlayer = 0
         currentWord = [String]()

    }
}

