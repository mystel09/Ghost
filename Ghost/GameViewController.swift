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
    private var targets = [TargetView]()
    var hud: HUDView!
    var selectedTile = ""
    //stopwatch variables
    private var secondsLeft: Int = 30
    private var timer: NSTimer?
    private var audioController: AudioController = {
        let audioController = AudioController()
        //audioController.preloadAudioEffects(AudioEffectFiles)
        return audioController
    }()
    var currentGame: Game?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "brownboard.gif")!)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func startStopwatch() {
        //initialize the timer HUD
        secondsLeft = timeToSolve
        hud.stopWatch.setSeconds(secondsLeft)
        
        //schedule a new timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"tick:", userInfo: nil, repeats: true)
    }
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
    @objc func tick(timer: NSTimer) {
        secondsLeft--
        hud.stopWatch.setSeconds(secondsLeft)
        if secondsLeft == 0 {
            self.stopStopwatch()
            addToScore()
        }
    }
    func checkForLossforRound() {
       var currentPlayer = currentGame!.getCurrentPlayer()
        
        //check
        
        //if the player is challenged and timer is up OR word is not in dictionary
        audioController.playEffect(SoundWrong)
        //stop the timer
        self.stopStopwatch()
        //add to his score
        
        // add letter on screen for player
        
    }
    func checkForLossforGame() -> Bool {
        if currentGame!.getCurrentPlayer().points == 5 {
            audioController.playEffect(SoundWrong)
            return true
        }
        return false
    }
   func addToScore(){
        currentGame!.getCurrentPlayer().points++
        if !checkForLossforGame() {
            //SHOW MESSAGE THAT USER LOST ROUND
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
        else {
            if let word = self.currentGame?.currentWord {
                return count(word)
            }
            else {
                return 0
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Tile", forIndexPath: indexPath) as! TileViewCell
        cell.layer.cornerRadius = 19.0
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "tile.png")!)
        cell.letterLabel.textColor = UIColor.whiteColor()
        
        if collectionView == self.keyboardCollectionView { //Keyboard collection view
            cell.layer.borderWidth = 5.0
            cell.letterLabel.text = Constants.Letters[indexPath.row]
            cell.delegate = self
            cell.layer.borderColor = UIColor.whiteColor().CGColor

        }
        else { //Current word collection view
            cell.layer.borderWidth = 4.0
            cell.layer.borderColor = self.currentGame?.getCurrentPlayer().playerColor.CGColor //changes by player turn
            self.currentGame?.getCurrentPlayer().playerColor
            cell.letterLabel.text = self.currentGame!.currentWord[indexPath.row]
        }
        
        return cell
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
            else { //word being spelled
                return CGSize(width: tileWidth/2, height: tileWidth)
            }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if collectionView == self.keyboardCollectionView {
            return CGFloat(Constants.NumberOfPointsInBetween)
        }
        else {
            return CGFloat(Constants.NumberOfPointsInBetween/3)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if collectionView == self.keyboardCollectionView {
            return CGFloat(Constants.NumberOfPointsInBetween)
        }
        else {
            return CGFloat(Constants.NumberOfPointsInBetween/2)
        }
    }
}

extension GameViewController: TileViewCellDelegate {
    func didTapOnTile(tile: TileViewCell) {
        println(tile.letterLabel.text)
        self.currentGame!.currentWord.append(tile.letterLabel.text!)
        self.wordCollectionView.reloadData()
    }
}
    














