//
//  GameViewController.swift
//  Anagrams
//
//  Created by TovaM on 7/6/15.
//  Copyright (c) 2015 Caroline. All rights reserved.
//

import UIKit

class GameViewController: UIViewController  {
    var gameView: UIView!
   // private var targets = [TargetView]()
    var selectedTile = ""
    var losingWord = "GHOST"
    var userChallenged = true
    var tField = UITextField?()
    //stopwatch variables
    @IBOutlet weak var stopwatch: UILabel!
    private var secondsLeft: Int = 3 //time in clock left
    private var timer: NSTimer?
    private var audioController: AudioController = {
        let audioController = AudioController()
        //audioController.preloadAudioEffects(AudioEffectFiles)
        return audioController
    }()
    var currentGame: Game?
    @IBOutlet weak var challengeButton: UIBarButtonItem!
    
     @IBAction func didChallenge(sender: UIBarButtonItem) {
        userChallenged = true
        stopStopwatch()
        currentGame?.goToLastPlayer() //challenges the player before him
        var alert = UIAlertController(title: "\(currentGame!.getCurrentPlayer().name), YOU HAVE BEEN CHALLENGED", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            var sizeOfWord = self.currentGame?.currentWord.count
            if sizeOfWord > count(self.tField!.text) {
                self.addToScore() // too small to even compare
                return
            }
            var subWord = self.tField!.text.substringToIndex(advance(self.tField!.text.startIndex, sizeOfWord!))
            var gameWord = "".join(self.currentGame!.currentWord)
            
            //check with dictionary
            if self.challenge(self.tField!.text) && subWord == gameWord.lowercaseString  { //if word exists then current player loses round
               //if word supplied is made of the games word
                    self.currentGame?.goToNextPlayer()
                    self.addToScore() // adds to player before the challenger
                }
                else {//if NOT then previous player loses round

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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "brownboard.gif")!)
        super.view.backgroundColor = UIColor(red: 200, green: 175, blue: 23, alpha: 0.4)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        stopwatch.text = "\(currentGame!.getCurrentPlayer().name)'s Turn" //get players turn
        startStopwatch()
    }
    func startStopwatch() {
        //initialize the timer HUD
        secondsLeft = timeToSolve
        stopwatch.text = "\(currentGame!.getCurrentPlayer().name) Start!" //get players turn
        
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
            // write on top whos turn it is
            currentGame?.goToNextPlayer()
            stopwatch.text = "\(currentGame!.getCurrentPlayer().name)'s Turn" //get players turn
        }
        else {
        stopwatch.text = "Time left:\(secondsLeft) secs"
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
        if currentGame!.getCurrentPlayer().points == 5 {
            return true
        }
        return false
    }
   func addToScore(){
        currentGame!.getCurrentPlayer().points++
        if !checkForLossforGame() {
            //showMessage("Attention Players", message: "\(currentGame!.getCurrentPlayer().name) lost this round")
            currentGame?.resetRound()
            self.wordCollectionView.reloadData()
            self.scoreCollectionView.reloadData()
        }
        else{
            audioController.playEffect(SoundWrong)
            self.scoreCollectionView.reloadData()
            stopwatch.text = "GAME OVER"
            self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
        }
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            if let word = self.currentGame?.currentWord {
                return count(word)
            }
            else {
                return 0
            }
        }
        else {
            return self.currentGame!.players.count
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
            cell.backgroundColor = self.currentGame?.colorOfLetters[indexPath.row]
            //cell.backgroundColor = UIColor(patternImage: UIImage(named: "tile.png")!)
            //cell.backgroundColor = self.currentGame?.players[indexPath.row % currentGame!.players.count].playerColor
            //cell.backgroundColor = self.currentGame?.getCurrentPlayer().playerColor
            cell.letterLabel.textColor = UIColor.whiteColor()
            cell.layer.borderWidth = 5.0
            cell.letterLabel.text = self.currentGame!.currentWord[indexPath.row]
            cell.layer.borderColor = UIColor.clearColor().CGColor

            return cell
        }
        else { //scores
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("score", forIndexPath: indexPath) as! PlayerStatusCell
            cell.layer.borderWidth = 5.0
            cell.layer.cornerRadius = 19.0
            cell.GhostLabel.text = losingWord.substringToIndex(advance(losingWord.startIndex, self.currentGame!.players[indexPath.row].points))
            cell.PlayerInfoLabel.text = self.currentGame?.players[indexPath.row].name
            cell.PlayerInfoLabel.textColor = UIColor.whiteColor()
            cell.layer.borderColor = UIColor.clearColor().CGColor

            if self.currentGame?.players[indexPath.row].points == 5 {
                cell.layer.borderColor = UIColor.blackColor().CGColor
            }
          
            //cell.PlayerInfoLabel.textColor = self.currentGame?.players[indexPath.row].playerColor
            cell.layer.backgroundColor = self.currentGame?.players[indexPath.row % currentGame!.players.count].playerColor.CGColor
            
            
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
 func showMessage(title: String, message: String) {
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.textFieldAtIndex(0)
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
}// end of class

extension GameViewController: TileViewCellDelegate {
    func didTapOnTile(tile: TileViewCell) {
        println(tile.letterLabel.text)
        println(self.currentGame?.indexOfCurrentPlayer)
        self.currentGame!.currentWord.append(tile.letterLabel.text!) // appends letter to current word
        self.currentGame!.colorOfLetters.append(self.currentGame!.getCurrentPlayer().playerColor)
        self.wordCollectionView.reloadData()
        stopStopwatch()
        // write on top whos turn it is
        currentGame?.goToNextPlayer()
        startStopwatch()
    }
}










