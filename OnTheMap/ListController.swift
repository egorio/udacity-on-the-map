//
//  ListController.swift
//  OnTheMap
//
//  Created by Egorio on 2/5/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
    
    func refresh() {
        self.tableView.reloadData()
    }

    /*
     * Return table cell count
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.shared.students.count
    }

    /*
     * Return one cell to the table
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = Storage.shared.students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell")!

        cell.imageView?.image = UIImage(named: "icon-pin")
        cell.textLabel?.text = student.fullName
        cell.detailTextLabel?.text = student.mediaUrl

        return cell
    }

    /*
     * Try to open user's link when cell is tapped
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openUrl(Storage.shared.students[indexPath.row].mediaUrl)
    }
}