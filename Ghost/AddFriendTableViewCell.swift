//
//  AddFriendTableViewCell.swift
//  Ghost
//
//  Created by TovaM on 7/22/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

protocol AddFriendTableViewCellDelegate: class {
    func cell(cell: AddFriendTableViewCell, didSelectUserToPlay user: PFUser)
    func cell(cell: AddFriendTableViewCell, didUnSelectUserToPlay user: PFUser)
}


class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: AddFriendTableViewCellDelegate?
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
        }
    }
    var canSelect: Bool? = true {
        didSet {
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canSelect = canSelect {
                selectButton.selected = !canSelect //if not selected then select it
            }
//            else {
//                selectButton.selected = canSelect! //if selected then unselect it
//            }
        }
    }
    @IBAction func selectButtonTapped(sender: AnyObject) {
        if let canSelect = canSelect where canSelect == true {
            delegate?.cell(self, didSelectUserToPlay: user!)
            // change image of icon
            self.canSelect = false
        } else {
            delegate?.cell(self, didUnSelectUserToPlay: user!)
            // plus icon
            self.canSelect = true
        }
    }
}
