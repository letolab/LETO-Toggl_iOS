//
//  ProjectsRowController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 01/08/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import WatchKit

class ProjectsRowController: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var mainGroup: WKInterfaceGroup!
    
    var project : Project? {
        didSet {
            titleLabel.setText(project!.name)
            mainGroup.setBackgroundColor(WatchUtils.getColorFromIndex(Int(project!.color)!))
        }
    }
    
    
}
