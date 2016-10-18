//
//  RoundedUILabel.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 11/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedUILabel : UILabel {
    
    var edgeInsets:UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)

    
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
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);
        
        return rect
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}