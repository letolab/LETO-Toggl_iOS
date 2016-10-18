//
//  ProjectsViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 28/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NBMaterialDialogIOS

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate{
    
    var data = [[Project]]()
    var sectionsName = [String]()
    var clientsID = [Int]()
    
    var selectedProj : Project?

    @IBOutlet weak var tableView: UITableView!
    
    let HEADER_HEIGHT : CGFloat = 50

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        getProjects()
    }
    
    func getProjects(){
        LoadingView.sharedInstance.show(self.view)
        LetoTogglRestClient.sharedInstance.getProjectsListWithClientInfo(workspaceID: AppPreferences.getWorksapceID() as! Int, success: { (projects) in
                LoadingView.sharedInstance.hide()
                self.createSections(projects)
            }) { (error) in
                LoadingView.sharedInstance.hide()
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        }
    }
    
    func createSections(projects:[Project]){
        let sortedProjects = projects.sort({ $0.clientObj.name < $1.clientObj.name })
        for proj:Project in sortedProjects{
                var itemIndex = -1
                for clientID in clientsID{
                    if proj.cid == clientID {
                        itemIndex = clientsID.indexOf(clientID)!
                        break
                    }
                }
                
                if itemIndex == -1 {
                    sectionsName.append(proj.clientObj.name!)
                    clientsID.append(proj.cid!)
                    var newSection = [Project]()
                    newSection.append(proj)
                    data.append(newSection)
                }else{
                    data[itemIndex].append(proj)
                }
        }
        tableView.reloadData()
    }
    
    //MARK table view delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return data[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell", forIndexPath: indexPath) as! ProjectCell
        
        let projectEntry = data[indexPath.section][indexPath.row]
        
        
        cell.projectName.text=projectEntry.name!
        cell.mainView.backgroundColor = AppUtils.getColorFromIndex(Int(projectEntry.color)!)
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProj = data[indexPath.section][indexPath.row]
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let leftMargin :CGFloat = 16
        let titleLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: tableView.frame.size.width - leftMargin, height: HEADER_HEIGHT))
        titleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightBold)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.text = sectionsName[section]
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    //MARK navigation delegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? NewTaskViewController {
            if selectedProj != nil {
                controller.selectedProj = self.selectedProj!
            }
        }
    }
}
