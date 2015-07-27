//
//  Ghost
//
//  Created by TovaM on 7/20/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//
//
//  CreateGameViewController.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit

class CreateGameViewControllerP: UITableViewController, GKGameCenterControllerDelegate {
    
    var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]
    var newGame: GameP = GameP()
    var currentNumberOfPlayers = 0
    var lastSelectedIndexPath :NSIndexPath?

    var gcEnabled = Bool() // Stores if the user has Game Center enabled

    struct Constants {
        static let maxNumberOfPlayers = 4
        static let minNumberOfPlayers = 2
        static let GamessHeaderIdentifier = "GamesHeader"
        static let GamessCellIdentifier = "GamesCell"
        static let WordSizeCellIdentifier = "WordSize"
        static let StartButtonCellIdentifier = "StartButton"
        static let SettingsIdentifier = "Settings"
        static let StartGameSegue = "StartOnlineGameSegue"
        static let WordSizeTag = 100
    }
    
    override func viewDidAppear(animated: Bool) {
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:
        self.authenticateLocalPlayer()
//        self.newGame.playersP.append(PlayerP(name: "", playerColor: colors.count-1))
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greybrick.gif")!) //background color
        tableView.delegate = self
    }
            
        
    @IBAction func StartGame(sender: AnyObject) {
        //check if at least one other player
        
        
        self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self)
    }
    // saving an instance of the game to use in the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Constants.StartGameSegue) {
            //game
            if let navVC = segue.destinationViewController as? UINavigationController {
                let CreateGameViewControllerP = navVC.topViewController as! GameViewControllerP
                CreateGameViewControllerP.currentGame = newGame
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            getPlayers()
        }
    }
    
    func getPlayers() {
        var request: GKMatchRequest = GKMatchRequest()
        var gamecontrol: GKTurnBasedMatchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        
        request.minPlayers = 2
        request.maxPlayers = 4
        
        gamecontrol.turnBasedMatchmakerDelegate = self
        //        gamecontrol.showExistingMatches
        
        self.presentViewController( gamecontrol, animated: true, completion: nil)
        
        

    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.GamessCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell
        }
        else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.StartButtonCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        else {
        
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SettingsIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
 
        }
    }
        override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                
            let identifier = Constants.GamessHeaderIdentifier
            
        let headerCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UIView!
        return headerCell
        }
        return nil
            
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return 64.0
        }
        return 44.0
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64.0
        }
        else {
            
        return 0
        }
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(ViewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
            
        }
        
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CreateGameViewController: GKMatchDelegate {
    
    var players: [AnyObject]! {
        get {
         return self.players
        }
    } // GKPlayers in the match
    
    //var delegate: GKMatchDelegate!
    var expectedPlayerCount: Int {
        get {
            return self.expectedPlayerCount
        }
    }
    
    func match(match: GKMatch!, didReceiveData data: NSData!, fromRemotePlayer player: GKPlayer!) {
        
    }
    
    func match(theMatch: GKMatch!, didReceiveData data: NSData!, fromPlayer playerID: String!) {
        
        
    }
    
    // The player state changed (eg. connected or disconnected)
    func match(match: GKMatch!, player: GKPlayer!, didChangeConnectionState state: GKPlayerConnectionState) {
        
    }
    
    func match(match: GKMatch!, didFailWithError error: NSError!) {
        
    }
    
    func match(match: GKMatch!, shouldReinviteDisconnectedPlayer player: GKPlayer!) -> Bool {
        return true
    }
    
    func match(match: GKMatch!, shouldReinvitePlayer playerID: String!) -> Bool {
        return true
    }
    func hideMatchmaker() {
        if self.matchMakerController {
            self.matchMakerController.delegate = nil
            self.matchMakerController.dismissViewControllerAnimated(true, completion: nil)
            self.matchMakerController = nil
            }
    }
    
   
}
extension CreateGameViewControllerP: GKTurnBasedMatchmakerViewControllerDelegate {
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        self.hideMatchMaker()
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        return
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
       
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier(Constants.StartGameSegue, sender: match)
    }
}
