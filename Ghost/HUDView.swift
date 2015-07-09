
//
//  HUDView.swift
//  Anagrams
//
//  Created by TovaM on 7/7/15.
//  Copyright (c) 2015 Caroline. All rights reserved.
//

import UIKit

class HUDView: UIView {
        
        var stopWatch: StopWatchView
        var gamePoints: CounterLabelView
    
        //this should never be called
        required init(coder aDecoder:NSCoder) {
            fatalError("use init(frame:")
        }
        
        override init(frame:CGRect) {
            self.stopWatch = StopWatchView(frame:CGRectMake(ScreenWidth/2-150, 0, 300, 100))
            self.stopWatch.setSeconds(0)
            
            //the dynamic points label
            self.gamePoints = CounterLabelView(font: FontHUD, frame: CGRectMake(ScreenWidth-200, 30, 200, 70))
            gamePoints.textColor = UIColor(red: 0.38, green: 0.098, blue: 0.035, alpha: 1)
            gamePoints.value = 0
            
            super.init(frame:frame)
            self.addSubview(gamePoints)
            
            //"GHOST status" label
            var pointsLabel = UILabel(frame: CGRectMake(ScreenWidth-340, 30, 140, 70))
            pointsLabel.backgroundColor = UIColor.clearColor()
            pointsLabel.font = FontHUD
            pointsLabel.text = " Status:"
            self.addSubview(pointsLabel)
            
            self.addSubview(self.stopWatch)
            self.userInteractionEnabled = false

        }
    }
    

