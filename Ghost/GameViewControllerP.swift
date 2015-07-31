//
//  GameViewControllerP.swift
//  Ghost
//
//  Created by TovaM on 7/20/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit
import GameKit

class GameViewControllerP: UIViewController, GKLocalPlayerListener {
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var selectedTile = ""
        var losingWord = "GHOST"
        var matchOutcome: GKTurnBasedMatchOutcome?
        var userChallenged = true
        var tField = UITextField?() //for challenge
        //stopwatch variables
        @IBOutlet weak var stopwatch: UILabel!
        private var secondsLeft: Int = 3 //time in clock left
        private var timer: NSTimer?
        var currentGame: GameP?
        var authenticated = false
        var currentMatch: GKTurnBasedMatch!
        var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.view.backgroundColor = UIColor(red: 200, green: 175, blue: 23, alpha: 0.4)
        self.automaticallyAdjustsScrollViewInsets = false
        println(currentGame?.playersP)
        println("match \(currentMatch?.participants.description)")
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
            userChallenged = true
            stopStopwatch()
          //challenges the player before him
       
            var alert = UIAlertController(title: "\(currentGame?.lastPlayer), YOU HAVE BEEN CHALLENGED", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                
                var sizeOfWord = self.currentGame?.CurrentWord.count
                if sizeOfWord > count(self.tField!.text) {
                    //self.addToScore() // too small to even compare
                    self.currentGame?.lastPlayer?.points++
                    return
                }
                var subWord = self.tField!.text.substringToIndex(advance(self.tField!.text.startIndex, sizeOfWord!))
                var gameWord = "".join(self.currentGame!.CurrentWord)
                
                //check with dictionary
                if self.challenge(self.tField!.text) && subWord == gameWord.lowercaseString && count(gameWord) > self.currentGame?.MinWordSize { //if word exists then current player loses round
                    //if word supplied is made of the games word
                    //self.currentGame?.goToNextPlayer()
                  self.addToScore() // adds to player before the challenger
                }
                else {//if NOT then previous player loses round
                    
                    // add point to challengee, already called previous player
                    //self.addToScore()
                    self.currentGame?.lastPlayer?.points++

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
            //stopwatch.text = "\(getCurrentPlayer()!.name)'s Turn" //get players turn
            startTurn()
            
        }
        func startStopwatch() {
            //initialize the timer HUD
            secondsLeft = timeToSolve
            stopwatch.text = "\(getCurrentPlayer()!.name) Start!" //get players turn
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
                stopwatch.text = "\(getCurrentPlayer()!.name) has \(secondsLeft) secs"
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
        if((currentGame?.firstTurn) == false){
        currentGame = NSKeyedUnarchiver.unarchiveObjectWithData(currentMatch.matchData) as? GameP //current game variables being updated
        }
        
        scoreCollectionView.reloadData()
        wordCollectionView.reloadData()
        keyboardCollectionView.reloadData()
        startStopwatch()
    }
    func loadFriendPlayersWithCompletionHandler(_completionHandler: (([GKPlayer]?,
        NSError?) -> Void)?){
            
    }
        func addToScore(){
            getCurrentPlayer()!.points++
            println(getCurrentPlayer()!.points)
            if !checkForLossforGame() {
                showMessage("Attention Players", message: "\(getCurrentPlayer()!.name) lost this round")
                //currentGame?.resetRound()
                self.wordCollectionView.reloadData()
                self.scoreCollectionView.reloadData()
                currentGame?.lastPlayer = getCurrentPlayer()
               var gameData = NSKeyedArchiver.archivedDataWithRootObject(currentGame!)
            endTurn(currentMatch, gameData: gameData, nextParticipants: SortArray(currentMatch.participants as! [GKTurnBasedParticipant])) //ends the turn and goes to next player
                stopwatch.text = "\(currentMatch.participants[0].displayName)'s Turn" //get players turn
                
            }
           else{
                self.scoreCollectionView.reloadData()
                stopwatch.text = "GAME OVER"
                showMessage("GAME OVER", message: "\(getCurrentPlayer()!.name) lost this game")
                var gameData = NSKeyedArchiver.archivedDataWithRootObject(currentGame!)
                endMatch(currentMatch, finalGameData: gameData)
            }
       }
    func SortArray(var nextParticipant: [GKTurnBasedParticipant]) -> [GKTurnBasedParticipant]{
        var temp = nextParticipant
        for var i = 1; i < temp.count-1; i++
        {
            nextParticipant[i] = temp[i-1] as GKTurnBasedParticipant
        }
        nextParticipant[0] = temp[temp.count-1] as GKTurnBasedParticipant
        return nextParticipant
    }
    func getCurrentPlayer() -> PlayerP? {
        var currentP = currentMatch.currentParticipant.player.playerID
        println(currentP)
        for player in currentGame!.playersP {
            if player.playerID == currentP {
                println(player.playerID)
                return player
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
                return currentMatch.participants.count
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
                    
                else {
                    return CGSize(width: tileWidth*2, height: tileWidth/2)
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
            // match has updated, we could be current player
            if player.playerID == GKLocalPlayer.localPlayer().playerID {
            //reload new data
                startTurn()
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
        func endTurn ( match : GKTurnBasedMatch , gameData : NSData , nextParticipants : [ GKTurnBasedParticipant ]) {
            // nextParticipants is the array of the players 
            // in the match, in order of who should go next. You can get the list 
            // of participants using match.participants. Game Center will tell the 
            // first participant in the array that it's his turn; if he doesn't 
            // take it within 600 seconds (10 minutes), it will be the next player's 
            // turn, and so on. (If the last participant in the array 
            // doesn't complete his turn within 10 minutes, it remains her  turn.) 
            
            match.endTurnWithNextParticipants(nextParticipants, turnTimeout: 600.0 ,matchData: gameData) { ( error ) in // We're done telling Game Center about the state of the game
                
        }
    }
        
        
}// end of class
    
    extension GameViewControllerP: TileViewCellDelegate {
        func didTapOnTile(tile: TileViewCell) {
            println(tile.letterLabel.text)
            println(getCurrentPlayer()!.name)
            
            self.currentGame?.CurrentWord.append(tile.letterLabel.text!) // appends letter to current word
            self.currentGame?.Color.append(getCurrentPlayer()!.color)
            self.wordCollectionView.reloadData()
            var gameWord = "".join(self.currentGame!.CurrentWord)
            
//            //check with dictionary
//            if self.challenge(gameWord) && count(gameWord) >= currentGame!.MinWordSize {
//                stopStopwatch()
//                addToScore() //this auto adds when someone spells a word, too easy
//            }
            stopStopwatch()
            // write on top whos turn it is
            currentGame?.lastPlayer = getCurrentPlayer()
            var gameData = NSKeyedArchiver.archivedDataWithRootObject(currentGame!)
            endTurn(currentMatch, gameData: gameData, nextParticipants: SortArray(currentMatch.participants as! [GKTurnBasedParticipant])) //ends the turn and goes to next player
            stopwatch.text = "\(currentMatch.participants[0].displayName)'s Turn" //get players turn        
        
        }
}







