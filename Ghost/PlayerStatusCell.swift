//
//  PlayerStatusCell.swift
//  Ghost
//
//  Created by TovaM on 7/9/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit


class PlayerStatusCell: UICollectionViewCell{
    @IBOutlet weak var PlayerInfoLabel: UILabel!
    @IBOutlet weak var GhostLabel: UILabel!

    
    var player: Player? {
        didSet {
            if let nameField = PlayerInfoLabel{
                    nameField.text = self.player?.name
                    nameField.backgroundColor = self.player?.playerColor
            }
        }
    }

    
}
