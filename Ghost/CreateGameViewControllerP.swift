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

class CreateGameViewControllerP: UITableViewController, UITextFieldDelegate {
    var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]
    var newGame: GameP = GameP()
    var currentNumberOfPlayers = 0
    var lastSelectedIndexPath :NSIndexPath?

    struct Constants {
        static let maxNumberOfPlayers = 4
        static let minNumberOfPlayers = 2
        static let PlayersHeaderIdentifier = "PlayersHeader"
        static let WordSizeCellIdentifier = "WordSize"
        static let StartButtonCellIdentifier = "StartButton"
        static let AddPlayerCellIdentifier = "AddPlayer"
        static let PlayerCellIdentifier = "Player"
        static let SettingsIdentifier = "SettingsHeader"
        static let StartGameSegue = "StartOnlineGameSegue"
        static let FindFriendsIdentifier = "FindFriends"
        static let WordSizeTag = 100
    }
    
    override func viewDidAppear(animated: Bool) {
        var players = PFUser.currentUser()!["playedWith"] as? [PFUser]
        // query.findObjectsInBackgroundWithBlock { ( results: [AnyObject]?, error: NSError?) -> Void in
        //                if error != nil {
        //                    println("error")
        //                    return
        //                }
        //                let results = results as? [PFObject] ?? []
        if  players?.count > 0 {
        for player in players! { //getting all newly added players
            self.newGame.playersP.append(PlayerP(name: player["username"]! as! String, playerColor: self.colors.count-1))
            self.colors.removeLast() //remove that from array, while using the last color
            self.currentNumberOfPlayers++
        }
        tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:
//        self.newGame.playersP.append(PlayerP(name: "", playerColor: colors.count-1))
//        self.colors.removeLast() //remove that from array, while using the last color
//        self.newGame.playersP.append(PlayerP(name: "", playerColor: colors.count-1))
//        self.colors.removeLast()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greybrick.gif")!) //background color
    }
    
    @IBAction func AddPlayer(sender: AnyObject) { //finding fellow users through parse
//        var query = PFQuery(className:"playedWith")
//        
//        query.findObjectsInBackgroundWithBlock { ( results: [AnyObject]?, error: NSError?) -> Void in
//            if error != nil {
//                println("error")
//                return
//            }
//                let results = results as? [PFObject] ?? []
//                
//                for player in results { //getting all newly added players
//                    self.newGame.playersP.append(PlayerP(name: player["username"]! as! String, playerColor: self.colors.count-1))
//                    self.colors.removeLast() //remove that from array, while using the last color
//                    self.currentNumberOfPlayers++
//                }
//            self.tableView.reloadData()
//
//            }
         }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "Save" {
            //var query = PFQuery(className["playedWith"]
            var players: [PlayerP] = PFUser.currentUser()!["playedWith"] as! [PlayerP]
           // query.findObjectsInBackgroundWithBlock { ( results: [AnyObject]?, error: NSError?) -> Void in
//                if error != nil {
//                    println("error")
//                    return
//                }
//                let results = results as? [PFObject] ?? []
            
                for player in players { //getting all newly added players
                    self.newGame.playersP.append(PlayerP(name: player["username"]! as! String, playerColor: self.colors.count-1))
                    self.colors.removeLast() //remove that from array, while using the last color
                    self.currentNumberOfPlayers++
                }
                self.tableView.reloadData()
                
        }
    }
    
    @IBAction func StartGame(sender: AnyObject) {
        //check if all names are filled
        
        for player in self.newGame.playersP {
            println(player.name)
            if player.name == "" {
                showMessage("Error!", message: "Please select a player to play with.")
                return
            }
        }
        
        self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self)
    }
    // saving an instance of the game to use in the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StartOnlineGameSegue") {
            //game
            if let navVC = segue.destinationViewController as? UINavigationController {
                let CreateGameViewControllerP = navVC.topViewController as! GameViewControllerP
                CreateGameViewControllerP.currentGame = newGame
                newGame.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                
                    if success == true {
                        println("game saved")
                        return
                    }
                  }
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
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.newGame.playersP.count == Constants.maxNumberOfPlayers {
                return self.newGame.playersP.count
            }
            else {
                return self.newGame.playersP.count+1
            }
        }
        else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.newGame.playersP.count != Constants.maxNumberOfPlayers && indexPath.row == self.tableView(self.tableView, numberOfRowsInSection: 0)-1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.AddPlayerCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.PlayerCellIdentifier, forIndexPath: indexPath) as! PlayerViewCell
            cell.playerP = self.newGame.playersP[indexPath.row]
            //cell.nameField.delegate = self
            cell.nameField.tag = indexPath.row

            return cell
        }
        else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.WordSizeCellIdentifier, forIndexPath: indexPath) as! WordSizeCellTableViewCell
                cell.wordSizeTextField.tag = Constants.WordSizeTag
                cell.wordSizeTextField.delegate = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.StartButtonCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell
                
            }
        }
    }
        override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = section == 0 ? Constants.PlayersHeaderIdentifier : Constants.SettingsIdentifier
        let headerCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        //headerCell.backgroundColor = UIColor.lightGrayColor()
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
}
