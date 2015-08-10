//
//  GameViewControllerP.swift
//  Ghost
//
//  Created by TovaM on 7/20/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit

protocol gameViewDelegate {
    func handleExit()
}
class GameViewControllerP: UIViewController, GKLocalPlayerListener {
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var selectedTile = ""
        var losingWord = "GHOST"
        var tField = UITextField?() //for challenge
        //stopwatch variables
        @IBOutlet weak var stopwatch: UILabel!
        private var secondsLeft: Int = 3 //time in clock left
        private var timer: NSTimer?
        var currentGame: GameP?
        var authenticated = false
        var currentMatch: GKTurnBasedMatch? {
        didSet {
            if currentMatch != nil {
                self.wordCollectionView?.reloadData()
                self.scoreCollectionView?.reloadData()
            }
        }
    }
    var delegate: gameViewDelegate?

    var colors: [UIColor] = [ Colors.Pink,Colors.Green,Colors.Purple,Colors.Blue]

    
    //new color wheel
        var currentPlayerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor(red: 200, green: 175, blue: 23, alpha: 0.4)
        self.automaticallyAdjustsScrollViewInsets = false

    }
    // MARK: Internal functions
    
        func authenticationChanged() {
            if GKLocalPlayer.localPlayer().authenticated && !authenticated {
                println("Authentication changed: player authenticated")
                authenticated = true
            } else {
                println("Authentication changed: player not authenticated")
                authenticated = false
            }
        }

    @IBOutlet weak var challengeButton: UIBarButtonItem!
        
        @IBAction func didChallenge(sender: UIBarButtonItem) {
            if currentMatch?.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
                //if currentGame?.lastPlayer != getCurrentPlayer(){
            stopStopwatch()
          //challenges the player before him
            showMessage("Attention Players:", message:"You CHALLENGED \(currentGame!.lastPlayer!.name)")

            currentGame?.lastPlayer?.wasChallenged = true //setting the challenge to true
            cleanupTurn()
            //}
        }
    }
   
    func challenge() {
        self.getCurrentPlayer()?.wasChallenged = false // resetting the value
        var alert = UIAlertController(title: "\(currentMatch!.currentParticipant.player.alias), YOU HAVE BEEN CHALLENGED", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            var sizeOfWord = self.currentGame?.CurrentWord.count
            if sizeOfWord > count(self.tField!.text) {
                self.addToScore() // too small to even compare
                return
            }
            var subWord = self.tField!.text.substringToIndex(advance(self.tField!.text.startIndex, sizeOfWord!))
            var gameWord = "".join(self.currentGame!.CurrentWord)
            
            //check with dictionary
            if self.challenge(self.tField!.text) && subWord == gameWord.lowercaseString { //if word exists then next player loses round
                //if word supplied is made of the games word
//                if self.currentPlayerIndex+1 == self.currentGame?.playersP.count {
//                    self.currentGame?.playersP[0].points++
//                     self.getCurrentPlayer()?.wasChallenged = false
//                    self.cleanupTurn()
//                }
//                else {
//                    self.currentGame?.playersP[self.currentPlayerIndex+1].points++
//                    self.getCurrentPlayer()?.wasChallenged = false
//                    self.cleanupTurn()
//                }
                self.currentGame?.gameStarted = true //player challenged won challenge
                self.cleanupTurn()
            }
            else {//if NOT then current player loses round
                
                // add point to challengee, already called previous player
                self.addToScore()
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
        })

    }
        func configurationTextField(textField: UITextField!)
        {
            textField.placeholder = "Enter your word here"
            tField = textField
            
        }
        
        @IBOutlet weak var keyboardCollectionView: UICollectionView! {
            didSet {
                self.keyboardCollectionView.dataSource = self
                self.keyboardCollectionView.delegate = self
            }
        }
        @IBOutlet weak var wordCollectionView: UICollectionView! {
            didSet {
                self.wordCollectionView.dataSource = self
                self.wordCollectionView.delegate = self
            }
        }
        @IBOutlet weak var scoreCollectionView: UICollectionView! {
            didSet {
                self.scoreCollectionView.dataSource = self
                self.scoreCollectionView.delegate = self
            }
        }
        
    
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            stopwatch.text = "\(currentMatch!.currentParticipant.player.alias)'s Turn" //get players turn
            //println("current word is: \(currentGame?.CurrentWord)")
            startTurn()
    }
        func startStopwatch() {
            //initialize the timer HUD
            secondsLeft = timeToSolve
            stopwatch.text = "\(currentMatch!.currentParticipant.player.alias) Start!"
            println("\(getCurrentPlayer()!.name) Start!") //get players turn
            //schedule a new timer
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"tick:", userInfo: nil, repeats: true)
            
        }
        func stopStopwatch() {
            timer?.invalidate()
            timer = nil
            
        }
        @objc func tick(timer: NSTimer) {
            secondsLeft--
            if secondsLeft == 0 {
                stopStopwatch()
                addToScore()
            }
            else {
                //stopwatch.text = "\(getCurrentPlayer()!.name) has \(secondsLeft) sec(s) left"
                stopwatch.text = "\(currentMatch!.currentParticipant.player.alias) has \(secondsLeft) sec(s) left"

            }
        }
        
        func challenge(guess :String) -> Bool{ //add challenge button and functionality
            let dictionary = Lexicontext.sharedDictionary()
            if dictionary.containsDefinitionFor(guess) {
                return true
            }
            else {
                return false
            }
        }
        func checkForLossforGame() -> Bool {
           if getCurrentPlayer()!.points == 5 {
                return true
            }
            return false
 
        }
    func startTurn() {
        if currentMatch?.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
            //reload new data
            if getCurrentPlayer()!.wasChallenged {
                challenge()
            }
            else if currentGame?.gameStarted == true { // he lost challenge
                currentGame?.gameStarted = false //reset value
                addToScore()
            }
            else {
                scoreCollectionView.reloadData()
                wordCollectionView.reloadData()
                keyboardCollectionView.reloadData()
                startStopwatch()
            }
        }
        else {
            println("not your turn")
        }
    }
    
        func addToScore(){
            getCurrentPlayer()!.points++
            if !checkForLossforGame() { //if current player lost this round but NOT the whole game
                  showMessage("Attention Players", message: "\(currentMatch!.currentParticipant.player.alias) has lost this round")
                currentGame?.CurrentWord = []
                self.wordCollectionView.reloadData()
                self.scoreCollectionView.reloadData()
                println("current player index \(currentPlayerIndex)")
                cleanupTurn()
            }
           else{
                self.scoreCollectionView.reloadData()
                stopwatch.text = "GAME OVER"
                var gameData = NSKeyedArchiver.archivedDataWithRootObject(currentGame!)
                endMatch(currentMatch!, finalGameData: gameData)
                showMessage("GAME OVER", message: "\(currentMatch!.currentParticipant.player.alias) lost this game")
                //currentMatch!.currentParticipant.matchOutcome.LOST = 1 //have to set match outcome
            }
       }
    func SortArray() -> [GKTurnBasedParticipant]{ //this makes the next player, the previous
        var temp: [GKTurnBasedParticipant] = currentMatch?.participants as! [GKTurnBasedParticipant]
        //        for var i = 1; i < temp.count; i++
//        {
//            nextParticipants[i] = temp[i-1] as GKTurnBasedParticipant
////        }
//        var tPlayer: GKTurnBasedParticipant = temp.removeLast()
//        temp[0] = tPlayer
//        temp.append(currentMatch!.currentParticipant)
        println(temp[0].playerID)
        temp = temp.reverse()
        println(temp[0].playerID)
        return temp
    }

        func getCurrentPlayer() -> PlayerP? {
        var currentP = currentMatch?.currentParticipant.player.playerID
        var tracker: Int = 0
        for player in currentGame!.playersP {
            if player.playerID == currentP {
                self.currentPlayerIndex = tracker
                return player
            }
            else {
            tracker++
            }

        }
        return nil
    }
    enum GKTurnBasedMatchOutcome : Int {
        case None
        case Quit
        case Won
        case Lost
        case Tied
        case TimeExpired
        case First
        case Second
        case Third
        case Fourth
    }


}
    extension GameViewControllerP: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        struct Constants {
            static let Letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",
                "S","T","U","V","W","X","Y","Z" ]
            static let NumberOfTilesPerRow = 6
            static let NumberOfPointsInBetween = 5.0
        }
        
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.keyboardCollectionView {
                return Constants.Letters.count
            }
            else if collectionView == wordCollectionView {
                if let word = self.currentGame?.CurrentWord {
                    return count(word)
                }
                else {
                    return 0
                }
            }
            else {
                return currentMatch?.participants.count ?? 0
            }
        }
        
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            
            if collectionView == self.keyboardCollectionView { //Keyboard collection view
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Tile", forIndexPath: indexPath) as! TileViewCell
                cell.layer.cornerRadius = 19.0
                //cell.backgroundColor = UIColor(patternImage: UIImage(named: "tile.png")!) //background image
                cell.backgroundColor = UIColor.darkGrayColor()
                cell.letterLabel.textColor = UIColor.whiteColor()
                cell.layer.borderWidth = 5.0
                cell.letterLabel.text = Constants.Letters[indexPath.row]
                cell.delegate = self
                cell.layer.borderColor = UIColor.clearColor().CGColor // border of tile
                return cell
                
            }
            else if collectionView == self.wordCollectionView {
                //Current word collection view
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Tile", forIndexPath: indexPath) as! TileViewCell
                cell.layer.cornerRadius = 19.0
                cell.backgroundColor = self.currentGame?.Color[indexPath.row]
                cell.letterLabel.textColor = UIColor.whiteColor()
                cell.layer.borderWidth = 5.0
                cell.letterLabel.text = self.currentGame!.CurrentWord[indexPath.row]
                cell.layer.borderColor = UIColor.clearColor().CGColor
                
                return cell
            }
            else { //scores
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("score", forIndexPath: indexPath) as! PlayerStatusCell
                cell.layer.borderWidth = 5.0
                cell.layer.cornerRadius = 19.0
                cell.GhostLabel.text = losingWord.substringToIndex(advance(losingWord.startIndex, self.currentGame!.playersP[indexPath.row].points))
                cell.PlayerInfoLabel.text = self.currentGame?.playersP[indexPath.row].name
                cell.PlayerInfoLabel.textColor = UIColor.whiteColor()
                cell.layer.borderColor = UIColor.clearColor().CGColor
                
                if self.currentGame?.playersP[indexPath.row].points == 5 {
                    cell.layer.borderColor = UIColor.blackColor().CGColor
                }
                cell.layer.backgroundColor = self.currentGame!.playersP[indexPath.row].color.CGColor
                //println(self.currentGame!.playersP[indexPath.row].name)
                return cell
            }
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout:
            UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
                var width = collectionView.frame.width
                let spaceLength = CGFloat(Double(Constants.NumberOfTilesPerRow+1) * 5.0)
                width -= spaceLength
                let tileWidth = width / CGFloat(Constants.NumberOfTilesPerRow)
                
                if collectionView == self.keyboardCollectionView {
                    return CGSize(width: tileWidth, height: tileWidth)
                }
                else if collectionView == self.wordCollectionView { //word being spelled
                    return CGSize(width: tileWidth/2, height: tileWidth)
                }
                    
                else { //score blocks
                    return CGSize(width: tileWidth*3, height: tileWidth/2)
                }
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            if collectionView == self.keyboardCollectionView {
                return CGFloat(Constants.NumberOfPointsInBetween)
            }
            else if collectionView == self.wordCollectionView{
                return CGFloat(Constants.NumberOfPointsInBetween/3)
            }
            else {
                return CGFloat(Constants.NumberOfPointsInBetween)
            }
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            if collectionView == self.keyboardCollectionView {
                return CGFloat(Constants.NumberOfPointsInBetween)
            }
            else if collectionView == self.wordCollectionView{
                return CGFloat(Constants.NumberOfPointsInBetween/2)
            }
            else {
                return CGFloat(Constants.NumberOfPointsInBetween)
            }
        }
        //     @IBAction func restartGame(sender: AnyObject) {
        //        let alert: UIAlertView = UIAlertView()
        //        //alert.title = "Exit"
        //        alert.message = "Want to Play Again?"
        //        let yes = alert.addButtonWithTitle("Yes")
        //        let no = alert.addButtonWithTitle("No")
        //        alert.delegate = self  // set the delegate here
        //        alert.show()
        //        println("This line doesn't wait for the alert to be responded to.")
        //    }
        
        func showMessage(title: String, message: String) {
            let alertView = UIAlertView()
            alertView.title = title
            alertView.message = message
            alertView.textFieldAtIndex(0)
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        //MARK: - Game center methods
        func player(player: GKPlayer!, receivedTurnEventForMatch match: GKTurnBasedMatch!, didBecomeActive: Bool) {
            currentMatch = match
            if currentMatch?.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
                println("\(currentMatch?.currentParticipant.player.alias) is \(didBecomeActive)")
            // match has updated, we could be current player
            
            currentMatch?.loadMatchDataWithCompletionHandler({ (gameData, error) -> Void in
                self.currentGame = NSKeyedUnarchiver.unarchiveObjectWithData(gameData) as? GameP
                self.startTurn()
                })
            }
            else {
                stopwatch.text = currentMatch?.currentParticipant.player.alias
            }
        }
        func player(player: GKPlayer!, matchEnded match: GKTurnBasedMatch!) {
            // match ended
            for participant in match.participants as! [GKTurnBasedParticipant] {
                println("\(participant.player.alias)'s outcome: " + "\(participant.matchOutcome)" )
            }
            
        }
        func endMatch(match: GKTurnBasedMatch, finalGameData:NSData){
            
            
            match.endMatchInTurnWithMatchData(finalGameData, completionHandler: { error in
                // told game center that match ended
                self.performSegueWithIdentifier("RestartGame", sender: self)

            })
        }
       // func endTurn ( match : GKTurnBasedMatch , gameData : NSData , nextParticipants : [ GKTurnBasedParticipant ]) {
            // nextParticipants is the array of the players 
            // in the match, in order of who should go next. You can get the list 
            // of participants using match.participants. Game Center will tell the 
            // first participant in the array that it's his turn; if he doesn't 
            // take it within 600 seconds (10 minutes), it will be the next player's 
            // turn, and so on. (If the last participant in the array 
            // doesn't complete his turn within 10 minutes, it remains her  turn.) 
        
       //}
            //self.dismissViewControllerAnimated(true, completion: nil)
   // }
        
        
}// end of class
    
    extension GameViewControllerP: TileViewCellDelegate {
        func didTapOnTile(tile: TileViewCell) {
        if currentMatch?.currentParticipant.player.playerID == GKLocalPlayer.localPlayer().playerID {
            //if currentGame?.lastPlayer?.name != currentMatch?.currentParticipant.player.alias {
                self.currentGame?.CurrentWord.append(tile.letterLabel.text!) // appends letter to current word
                self.currentGame?.Color.append(getCurrentPlayer()!.color)
                self.wordCollectionView.reloadData()
                var gameWord = "".join(self.currentGame!.CurrentWord)
            
                    //check with dictionary
                if self.challenge(gameWord) && count(gameWord) >= currentGame!.MinWordSize {
                    stopStopwatch()
                    addToScore() //this auto adds when someone spells a word, too easy
                }
            stopStopwatch()
            cleanupTurn()
           // }
        
//        else {
//            println("you were last player, or pressed button")
//            }
        }
        else {
            println("not local player")
            }

    }
        func isMatchActive() {
            var localPlayer = GKLocalPlayer.localPlayer()
            if localPlayer.playerID == currentMatch?.currentParticipant.player.playerID {
                self.player(localPlayer, receivedTurnEventForMatch: currentMatch, didBecomeActive: true)
            }
            else {
                  NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(5), target: self, selector: "isMatchActive", userInfo: nil, repeats: false)
            }
        }
                func gameCenter() {
            //delegate!.handleExit()
            self.dismissViewControllerAnimated(true, completion: nil)


        }
        func cleanupTurn() {
            currentGame?.lastPlayer = getCurrentPlayer()
            var gameData = NSKeyedArchiver.archivedDataWithRootObject(currentGame!)

//            if currentGame?.lastPlayer?.wasChallenged == true { //if the last player was challenged
//                stopwatch.text =  "\(currentGame!.lastPlayer!.name)'s Turn"
            println("old participant \(currentMatch!.currentParticipant.player.alias)")
           // endTurn(currentMatch!, gameData: gameData, nextParticipants: currentMatch!.participants as! [GKTurnBasedParticipant]) //ends the turn and goes to next player
            currentMatch!.endTurnWithNextParticipants(SortArray() , turnTimeout: GKTurnTimeoutDefault ,matchData: gameData) { ( error ) in // We're done telling Game Center about the state of the game

            println("current participant \(self.currentMatch!.currentParticipant.player.alias)")
                if self.currentGame?.lastPlayer?.name == self.currentMatch?.currentParticipant.player.alias {
                    self.currentMatch!.endTurnWithNextParticipants(self.currentMatch?.participants , turnTimeout: GKTurnTimeoutDefault ,matchData: gameData) { ( error ) in // We're done telling Game Center about the state of the game
                        self.stopwatch.text = "\(self.currentMatch!.currentParticipant.player.alias)'s Turn" //get players turn
                        println("turn ended successfully")
                        println("current word should be: \(self.currentGame!.CurrentWord)")
                        println("last player was \(self.currentGame!.lastPlayer!.name))")
                        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10), target: self, selector: "gameCenter", userInfo: nil, repeats: false)
                    }
                }
                else {
                    println("turn ended successfully")
                    println("current word should be: \(self.currentGame!.CurrentWord)")
                    println("last player was \(self.currentGame!.lastPlayer!.name))")
                    NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10), target: self, selector: "gameCenter", userInfo: nil, repeats: false)
                }
                

            
            
//            }

//            else {
       
            //endTurn(currentMatch!, gameData: gameData, nextParticipants:currentMatch!.participants as! [GKTurnBasedParticipant]) //ends the turn and goes to next player
//            endTurn(currentMatch!, gameData: gameData, nextParticipants: participant!) //ends the turn and goes to next player
            //}

            }
        }
       
        
        @IBAction func goToGameCenter(sender: AnyObject) {
        delegate!.handleExit()
        }
        
}







