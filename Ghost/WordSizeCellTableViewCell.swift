//
//  WordSizeCellTableViewCell.swift
//  Ghost
//
//  Created by TovaM on 7/6/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

class WordSizeCellTableViewCell: UITableViewCell {
    @IBOutlet weak var wordSizeTextField: UITextField! {
        didSet {
            let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.frame.width, 50))
            toolbar.items = [UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "wordSizeDonePressed")]
            self.wordSizeTextField.inputAccessoryView = toolbar
        }
    }
    
    func wordSizeDonePressed() {
        self.wordSizeTextField.resignFirstResponder()
    }
}
