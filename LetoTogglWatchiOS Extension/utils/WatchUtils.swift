//
//  WatchUtils.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 25/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import UIKit

class WatchUtils {
    static let colors : [String] = ["#4dc3ff","#bc85e6","#df7baa","#f68d38","#b27636","#8ab734","#14a88e","#268bb5","#6668b4","#a4506c","#67412c","#3c6526","#094558","#bc2d07","#999999","#AEAEAE"]

    
    static func getDurationString (let initialDuration:Int) -> String{
        var duration = initialDuration;
        if duration<0 {
            let nowDouble = NSDate().timeIntervalSince1970
            duration = Int(nowDouble) + duration
        }
        let hours : Int = duration/3600
        var remainder : Int = duration - hours * 3600
        let mins : Int = remainder/60
        remainder = remainder - mins * 60
        let secs : Int = remainder
        
        return "\(hours)"+":"+String(format: "%02d", mins)+":"+String(format: "%02d", secs)
    }
    
    static func getColorFromIndex (index:Int) -> UIColor {
        return colorWithHexString(colors[index])
    }
    
    // Creates a UIColor from a Hex string.
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}