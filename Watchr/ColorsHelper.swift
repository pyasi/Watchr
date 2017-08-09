//
//  ColorsHelper.swift
//  Watchr
//
//  Created by Peter Yasi on 8/8/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import Foundation
import UIKit

func hexStringToUIColor (hex:String) -> UIColor {
    
    var rgbValue : UInt32 = 0
    Scanner(string: hex).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
