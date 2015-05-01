//
//  WhispersTableViewController.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class WhispersTableViewController: UITableViewController, WhisperRequestManagerDelegate {

    var section: Section? = .None {
        willSet {
            WhisperRequestManager.sharedInstance.requestForWhispers(newValue!)
        }
    }

    var whispers: [Whisper] = [Whisper]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        WhisperRequestManager.sharedInstance.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - WhisperRequestManager delegate methods

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        self.whispers = whispers
        if whispers.count > 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whispers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier",
            forIndexPath: indexPath) as! WhispersTableViewCell
        cell.whisper = whispers[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? WhispersTableViewCell {
            cell.whisperContentAttributedLabel.numberOfLines = 100
            cell.setNeedsUpdateConstraints()
            tableView.layoutIfNeeded()
        }
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? WhispersTableViewCell {
            cell.whisperContentAttributedLabel.numberOfLines = 15
            cell.setNeedsUpdateConstraints()
            tableView.layoutIfNeeded()
        }
    }

}
