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
    var matchStarted = false

    struct Constants {
        static let maxNumberOfPlayers = 4
        static let minNumberOfPlayers = 2
        static let SettingsIdentifier = "Settings"
        static let StartGameSegue = "StartOnlineGameSegue"
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
                for player in Globalmatch!.participants! as! [GKTurnBasedParticipant] {
                    
                    newGame.playersP.append(PlayerP(name: player.player.displayName!, playerColor: self.colors.removeLast()))
                }
                
                
                navVC.currentGame = newGame
                navVC.currentMatch = Globalmatch
                
            }
        }
    }
    
    func showMessage(title: String, message: String) {
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
   
    func endTurnWithNextParticipants(nextParticipants: [AnyObject]!,
        turnTimeout timeout: NSTimeInterval,
        matchData: NSData!,
        completionHandler: ((NSError!) -> Void)!){
            
    }
    
    func findMatchForRequest(_request: GKMatchRequest!,
        withCompletionHandler completionHandler: ((GKTurnBasedMatch!,
        NSError!) -> Void)!){
            self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self) //start game
    }
    func acceptInviteWithCompletionHandler(completionHandler: ((GKTurnBasedMatch!,
        NSError!) -> Void)!){
            //newGame.playersP.append(PlayerP(GKLocalPlayer.localPlayer() as! PlayerP)
            
    }
    
    func declineInviteWithCompletionHandler(completionHandler: ((NSError!) -> Void)!){
        
    }
    
    func getPlayers() {
        var request: GKMatchRequest = GKMatchRequest()
        request.minPlayers = Constants.minNumberOfPlayers
        request.maxPlayers = Constants.maxNumberOfPlayers
        request.defaultNumberOfPlayers = 2
        
        var gamecontrol: GKTurnBasedMatchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        
        
        
        gamecontrol.turnBasedMatchmakerDelegate = self
        self.presentViewController( gamecontrol, animated: true, completion: nil)
        
    }
        
       // MARK: - functions for game
    
    func loadMatchDataWithCompletionHandler (_completionHandler: ((NSData!,
        NSError!) -> Void)!) {
            
    }
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

    
    // The player state changed (eg. connected or disconnected)
    func match(match: GKMatch!, player: GKPlayer!, didChangeConnectionState state: GKPlayerConnectionState) {
        if state == GKPlayerConnectionState.StateDisconnected {
            // The player has disconnected; update the game's UI
            println("player disconnected")
        }
        else {
            println("player connected")
        }
    }
    
    func match(match: GKMatch!, didFailWithError error: NSError!) {
        
    }
    
    func match(match: GKMatch!, shouldReinviteDisconnectedPlayer player: GKPlayer!) -> Bool {
        return true
    }
    
    func match(match: GKMatch!, shouldReinvitePlayer playerID: String!) -> Bool {
        
        return true
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
        println("didFindMatch");
        println(match.participants.count)
        Globalmatch = match
        self.dismissViewControllerAnimated(true) {
        self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self)
        }
            lookupPlayers()
        //go to game
//        if match.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
//            // We are the current player.
//            
//        } else {
//            // Someone else is the current player. 
//        }
        //acceptInviteWithCompletionHandler { (match, error) -> Void in
        

       // }
    }
    func lookupPlayers() {
        println("Looking up \(Globalmatch?.participants.count) players...")
    }
}
    


