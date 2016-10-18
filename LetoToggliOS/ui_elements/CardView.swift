//
//  CardView.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView : UIView {
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