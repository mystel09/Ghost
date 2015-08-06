//
//  ViewController.swift
//  Ghost
//
//  Created by TovaM on 6/30/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit


class ChooseAGameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]
    var newGame: GameP = GameP()
    var Globalmatch: GKTurnBasedMatch?

    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var updatedGame: GameP?
    
    struct Constants {
        static let maxNumberOfPlayers = 4
        static let minNumberOfPlayers = 2
        static let SettingsIdentifier = "Settings"
        static let StartGameSegue = "StartOnlineGameSegue"
        static let ContinueGameSegue = "ContinueGameSegue"

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.authenticateLocalPlayer()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func StartGame(sender: AnyObject) {
        //check if at least one other player
        getPlayers()
    }
    // saving an instance of the game to use in the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Constants.StartGameSegue) {
            //game
            if let navVC = segue.destinationViewController as? GameViewControllerP {
                if Globalmatch?.participants.count != newGame.playersP.count{
                for player in Globalmatch!.participants! as! [GKTurnBasedParticipant] {
                    
                    newGame.playersP.append(PlayerP(name: player.player.alias!, playerColor: self.colors.removeLast(), playerID: player.player.playerID))
                }
                navVC.currentGame = newGame
                var gameData = NSKeyedArchiver.archivedDataWithRootObject(newGame)
                Globalmatch?.saveCurrentTurnWithMatchData(gameData, completionHandler: { (error) -> Void in
                    navVC.currentMatch = self.Globalmatch

                })
                }
            }
        }
       else if segue.identifier == Constants.ContinueGameSegue {
            println(updatedGame?.playersP)
            let navVC = segue.destinationViewController as? GameViewControllerP
            
            navVC?.currentGame = self.updatedGame
            println("game loading in match of \(self.Globalmatch?.participants.count)")
            navVC!.currentMatch = self.Globalmatch

        }
    }
    
    
    func showMessage(title: String, message: String) {
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
   
    
    func acceptInviteWithCompletionHandler(completionHandler: ((GKTurnBasedMatch!,
        NSError!) -> Void)!){
            println("accepting invitation")
            newGame.gameStarted = false
            self.dismissViewControllerAnimated(true) {
            self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self) //start game
            }
            
    }
    
    func getPlayers() {
        var request: GKMatchRequest = GKMatchRequest()
        request.minPlayers = Constants.minNumberOfPlayers
        request.maxPlayers = Constants.maxNumberOfPlayers
        request.defaultNumberOfPlayers = 2
        
        var gamecontrol: GKTurnBasedMatchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        

        gamecontrol.turnBasedMatchmakerDelegate = self
        self.presentViewController( gamecontrol, animated: true, completion: nil)
        //self.pendingInvite = nil
        request.recipients = self.newGame.playersP
    }
    
       // MARK: - functions for game
    func getFriendData(){
        GKLocalPlayer.localPlayer().loadFriendPlayersWithCompletionHandler { (friends, error) -> Void in
            // log out info about friends
            for friend in friends {
                println("Friend \(friend.displayName)")
            }
            self.newGame.playersP = friends as! [PlayerP]
        }
        
    }
    
    func authenticateLocalPlayer() {
        if let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer() {
            
            localPlayer.authenticateHandler = {(ViewController, error) -> Void in
                if((ViewController) != nil) { // We need to present a view controller to finish the authentication process
                    
                    // 1 Show login if player is not logged in
                    self.presentViewController(ViewController, animated: true, completion: nil)
                    
                } else if (localPlayer.authenticated) {
                    // 2 Player is already euthenticated & logged in, load game center
                    self.gcEnabled = true
                    
                    // Get the default leaderboard ID
                    //                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    //                    if error != nil {
                    //                        println(error)
                    //                    } else {
                    //
                    //                        }
                }
                else if let theError = error {
                    // 3 Game center is not enabled on the users device
                    self.gcEnabled = false
                    println("Local player could not be authenticated, disabling game center")
                    println(theError)
                    
                }
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension ChooseAGameViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        // The user cancelled the match-maker
        self.dismissViewControllerAnimated (true , completion: nil )
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        //failed to find a match
        self.dismissViewControllerAnimated(true, completion: nil)
               println("Error finding match: \(error.localizedDescription)")

    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        let matchData = match.matchData
        // Do something with the match data to reflect the fact that we're
        // quitting (e.g., give all of our buildings to someone else,
        
        match.participantQuitInTurnWithOutcome(GKTurnBasedMatchOutcome.Quit, nextParticipants: nil, turnTimeout: 2000.0, matchData : matchData ) { ( error ) in
            // We've now finished telling Game Center that we've quit
        }// or remove them from the game)
    }
    
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        //did find match
        println("didFindMatch")
        
        Globalmatch = match
        Globalmatch?.loadMatchDataWithCompletionHandler({ (gameData, error) -> Void in
            
            
            
            if gameData.length > 0 { //continue game setup
            self.updatedGame = NSKeyedUnarchiver.unarchiveObjectWithData(gameData) as? GameP
            println(self.updatedGame?.CurrentWord)
            //if (self.updatedGame?.gameStarted == true)  {
                
                self.dismissViewControllerAnimated(true) {
                    self.performSegueWithIdentifier(Constants.ContinueGameSegue, sender: self)
                }
            }
            else {
                //go to game
                //if match.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
                self.acceptInviteWithCompletionHandler { (match, error) -> Void in
                }
            }

        }) //updating game variables
    }
    
}
    


