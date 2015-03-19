//
//  NewDiscussionGroupPickerViewController.swift
//  gamer-ios
//
//  Created by Ian Sikora on 3/16/15.
//  Copyright (c) 2015 rocketu. All rights reserved.
//

import UIKit

class NewDiscussionGroupPickerViewController: UITableViewController {

    var groups:[GroupsNames] = []
    var selectedGroup:String? = nil
    var selectedGroupIndex:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadGroupData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as UITableViewCell
        let group = groups[indexPath.row] as GroupsNames
        
        cell.textLabel?.text = group.groupName
        
        if indexPath.row == selectedGroupIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedGroupIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedGroupIndex = indexPath.row
        selectedGroup = groups[indexPath.row].groupName
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    func reloadGroupData(){
        DataManager.getGroupsDataWithSuccess{ (groupsData) -> Void in
            println("Request returned")
            let json = JSON(data: groupsData)
            if let groupsArray = json.array {
                for group in groupsArray {
                    var groupName: String! = group["name"].string
                    var groupKey: Int! = group["pk"].int
                    var group = GroupsNames(groupName: groupName!, groupKey: groupKey)
                    self.groups.append(group)
                }
                println("Groups appended. Count \(self.groups.count)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    println("Async Table Reloaded")
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedGroup" {
            let cell = sender as UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            selectedGroupIndex = indexPath?.row
            if let index = selectedGroupIndex {
                selectedGroup = groups[index].groupName
                println(selectedGroup)
            }
        }
    }

}
