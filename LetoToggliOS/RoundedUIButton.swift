//
//  RoundedUIButton.swift
//  KaraokeOne
//
//  Created by Lorenzo Greco on 23/04/16.
//  Copyright © 2016 Alessandro Di Vito. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedUIButton : UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
}