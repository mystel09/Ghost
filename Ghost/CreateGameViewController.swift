//
//  CreateGameViewController.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class CreateGameViewController: UITableViewController, UITextFieldDelegate {
    var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]
    var newGame: Game = Game()
    
    struct Constants {
        static let maxNumberOfPlayers = 8
        static let minNumberOfPlayers = 2
        
        static let PlayersHeaderIdentifier = "PlayersHeader"
        static let WordSizeCellIdentifier = "WordSize"
        static let StartButtonCellIdentifier = "StartButton"
        static let AddPlayerCellIdentifier = "AddPlayer"
        static let PlayerCellIdentifier = "Player"
        static let SettingsIdentifier = "SettingsHeader"
        static let StartGameSegue = "StartGameSegue"
        static let WordSizeTag = 100
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:
        self.newGame.players.append(Player(name: "assd", playerColor: self.colors.removeLast()))
        self.newGame.players.append(Player(name: "asd", playerColor: self.colors.removeLast()))
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greybrick.gif")!) //background color
    }
    
    @IBAction func AddPlayer(sender: AnyObject) {
        self.newGame.players.append(Player(name: "", playerColor: self.colors.removeLast()))
        self.tableView.reloadData()
    }
    
    @IBAction func StartGame(sender: AnyObject) {
        //check if all names are filled
        
        for player in self.newGame.players {
            println(player.name)
            if player.name == "" {
                showMessage("Error!", message: "Please enter names of all players.")
                return
            }
        }
        
        self.performSegueWithIdentifier(Constants.StartGameSegue, sender: self)
    }
    // saving an instance of the game to use in the next controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StartGameSegue") {
            //game
            let CreateGameViewController = segue.destinationViewController as! GameViewController
            CreateGameViewController.currentGame = newGame
            
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
            if self.newGame.players.count == Constants.maxNumberOfPlayers {
                return self.newGame.players.count
            }
            else {
                return self.newGame.players.count+1
            }
        }
        else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.newGame.players.count != Constants.maxNumberOfPlayers && indexPath.row == self.tableView(self.tableView, numberOfRowsInSection: 0)-1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.AddPlayerCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.PlayerCellIdentifier, forIndexPath: indexPath) as! PlayerViewCell
            cell.player = self.newGame.players[indexPath.row]
            cell.nameField.delegate = self
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
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.tag == Constants.WordSizeTag {
            self.newGame.minWordSize = textField.text.toInt()!
        }
        else {
            let playerNumber = textField.tag
            let player = self.newGame.players[playerNumber]
            player.name = textField.text
        }
        
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
