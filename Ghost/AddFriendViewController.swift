//
//  AddFriendViewController.swift
//  Ghost
//
//  Created by TovaM on 7/21/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit

class AddFriendViewController: GKTurnBasedMatchmakerViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func joinGhostMatch(sender: AnyObject) {
        var request: GKMatchRequest = GKMatchRequest()
        var gamecontrol: GKTurnBasedMatchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)

        request.minPlayers = 2
        request.maxPlayers = 2
        
//        gamecontrol.turnBasedMatchmakerDelegate = self
//        gamecontrol.showExistingMatches
        
        self.presentViewController( gamecontrol, animated: true, completion: nil)
    }
    

}

extension AddFriendViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        return
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        return
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        return
    }
    
}

