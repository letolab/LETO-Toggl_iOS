//
//  ProjectView.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 11/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//


import Foundation

class ProjectView : UIView {
    
    @IBOutlet private var contentView:UIView?
    
    @IBOutlet var projectLabel : UILabel?
    @IBOutlet var timeLabel : UILabel?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("ProjectView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
    }
    
}