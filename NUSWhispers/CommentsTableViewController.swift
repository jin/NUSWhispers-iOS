//
//  CommentsTableViewController.swift
//  NUSWhispers
//
//  Created by jin on 8/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    var comments: [Comment]! = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! CommentsTableViewCell
        cell.comment = comments[indexPath.row]
        return cell
    }

}
