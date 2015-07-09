
//
//  CounterLabelView.swift
//  Anagrams
//
//  Created by TovaM on 7/7/15.
//  Copyright (c) 2015 Caroline. All rights reserved.
//

import UIKit

class CounterLabelView: UILabel {
    var losingWord = "GHOST"

    //1
    var value:Int = 0 {
        //2
        didSet {
            self.text = losingWord.substringToIndex(advance(losingWord.startIndex, value))
        }
    }
    
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(font:frame:")
    }
    
    //3
    init(font:UIFont, frame:CGRect) {
        super.init(frame:frame)
        self.font = font
        self.backgroundColor = UIColor.clearColor()
    }
    
}
