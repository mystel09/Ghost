//
//  TileViewCell.swift
//  Ghost
//
//  Created by TovaM on 7/8/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

protocol TileViewCellDelegate: class {
    func didTapOnTile(tile: TileViewCell)
}

class TileViewCell : UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!
    
    weak var delegate: TileViewCellDelegate?
    
    override func awakeFromNib() {
       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tileTapped")
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tileTapped() {
        delegate?.didTapOnTile(self)
    }
}
