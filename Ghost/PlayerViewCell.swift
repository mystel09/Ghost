//
//  PlayerViewCell.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class PlayerViewCell: UITableViewCell {

   
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var colorButton: UIButton! {
        didSet {
            self.colorButton.layer.cornerRadius = 5
        }
    }
    
    var colors: [UIColor] = [Colors.Red,Colors.Purple, Colors.Yellow, Colors.Pink,Colors.Orange,Colors.Green,Colors.Brown,Colors.Blue]

    var player: Player? {
        didSet {
            if let nameField = self.nameField,
                let colorButton = self.colorButton {
                    nameField.text = self.player?.name
                    colorButton.backgroundColor = self.player?.playerColor
            }
        }
    }
    var playerP: PlayerP? {
        didSet {
            if let nameField = self.nameField,
                let colorButton = self.colorButton {
                    nameField.text = self.playerP?.name
                    colorButton.backgroundColor = colors[self.playerP!.color]
            }
        }
    }

}
