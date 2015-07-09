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
        randomize()
    }
    
    func tileTapped() {
        delegate?.didTapOnTile(self)
    }
    
    let image = UIImage(named: "tile")!
     func randomize() {
        //1
        //set random rotation of the tile
        //anywhere between -0.2 and 0.3 radians
        let rotation = CGFloat(randomNumber(minX:0, maxX:50)) / 100.0 - 0.2
        self.transform = CGAffineTransformMakeRotation(rotation)
        
        //2
        //move randomly upwards
        let yOffset = CGFloat(randomNumber(minX: 0, maxX: 10) - 10)
        self.center = CGPointMake(self.center.x, self.center.y + yOffset)
    }

}
