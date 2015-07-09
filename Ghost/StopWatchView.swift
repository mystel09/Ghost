//
//  StopWatchView.swift
//  Anagrams
//
//  Created by TovaM on 7/7/15.
//  Copyright (c) 2015 Caroline. All rights reserved.
//

import UIKit

class StopWatchView: UILabel {
    
    //this should never be called
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.font = FontHUDBig

    }
    
    //helper method that implements time formatting
    //to an int parameter (eg the seconds left)
    func setSeconds(seconds:Int) {
        self.text = String(format: " %02i : %02i", seconds/60, seconds % 60)
    }
}
