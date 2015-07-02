//
//  PlayerViewCell.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class PlayerViewCell: UITableViewCell {

   
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var colorButton: UIButton! {
        didSet {
            self.colorButton.layer.cornerRadius = 5
        }
    }
    
    var player: Player? {
        didSet {
            if let nameField = self.nameField,
                let colorButton = self.colorButton {
                    nameField.text = self.player?.name
                    colorButton.backgroundColor = self.player?.playerColor
            }
        }
    }
    
}
