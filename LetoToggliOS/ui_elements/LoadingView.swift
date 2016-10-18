//
//  LoadingView.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 11/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingView: UIView {
    
    static let sharedInstance = LoadingView()
    
    @IBOutlet private var contentView:UIView?
    // other outlets
    @IBOutlet private var spinner: NVActivityIndicatorView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("LoadingView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
        spinner.startAnimation()
        self.hidden=true
    }
    
    func show (parentView:UIView){
        if self.hidden {
            let window = UIApplication.sharedApplication().keyWindow
            self.frame=(window?.frame)!
            self.hidden=false
            window!.addSubview(self)
        }
    }
    
    internal func hide (){
        if !self.hidden{
            UIView.animateWithDuration(0.3, animations: {
                self.alpha=0
                }, completion: { (finished) in
                    self.hidden=true
                    self.removeFromSuperview()
                    self.alpha=1
            })
        }
    }
}