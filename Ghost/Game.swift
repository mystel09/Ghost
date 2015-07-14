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
    var colorOfLetters = [UIColor]()
    
    func goToNextPlayer() {
        self.indexOfCurrentPlayer = (self.indexOfCurrentPlayer+1) % self.players.count
    }

    func getCurrentPlayer() -> Player {
        return players[indexOfCurrentPlayer]
    }
    func goToLastPlayer() {
        if self.indexOfCurrentPlayer == 0 {
            self.indexOfCurrentPlayer = self.players.count-1
        }
        else{
            self.indexOfCurrentPlayer = self.indexOfCurrentPlayer-1
        }
    }
    func resetRound() {
         indexOfCurrentPlayer = (self.indexOfCurrentPlayer+1) % self.players.count
         currentWord = [String]()
         colorOfLetters = [UIColor]()
    }
    
//    func resetGame() {
//        self.players = []
//        self.minWordSize = 4
//        self.indexOfCurrentPlayer = 0
//        self.currentWord = []
//        self.colorOfLetters = []
//    }
}

