//
//  Colors.swift
//  Ghost
//
//  Created by TovaM on 7/2/15.
//  Copyright (c) 2015 TovaProductions. All rights reserved.
//

import UIKit

struct Colors {
    static let Pink = UIColorFromRGB(0xFB3997)
    //static let Yellow = UIColor(red: 255/255.0, green: 222/255.0, blue: 98/255.0, alpha: 1)
    static let Green = UIColorFromRGB(0xAAEE70)
    static let Purple = UIColorFromRGB(0xBA54FF)
    //static let Orange = UIColor(red: 237/255.0, green: 123/255.0, blue: 47/255.0, alpha: 1)
    static let Blue = UIColorFromRGB(0x4EB5FE)
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}