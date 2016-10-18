//
//  BaseTableViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 04/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation

class BaseTableViewController: UITableViewController {

    let HEADER_HEIGHT : CGFloat = 50

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.alwaysBounceVertical = false;
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = MainPalette.whiteColor()
        self.navigationController?.navigationBar.barTintColor = MainPalette.primaryColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:navigationController, action:nil)
        //        AnswersTracking.trackEventScreen("BaseViewController Will Appear")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.98, alpha:1.00)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func createHeaderWithTitle(title:String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let leftMargin :CGFloat = 16
        let titleLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: tableView.frame.size.width - leftMargin, height: HEADER_HEIGHT))
        titleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightBold)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.text = title
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
}
