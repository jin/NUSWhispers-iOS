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
import SVPullToRefresh

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

        tableView.addPullToRefreshWithActionHandler {
            if let section = self.section {
                WhisperRequestManager.sharedInstance.requestForWhispers(
                    section,
                    offset: 0)
            } else {
                self.tableView.pullToRefreshView.stopAnimating()
            }
        }

        tableView.addInfiniteScrollingWithActionHandler {
            if let section = self.section {
                WhisperRequestManager.sharedInstance.requestForWhispers(
                    section,
                    offset: self.whispers.count)
            } else {
                self.tableView.infiniteScrollingView.stopAnimating()
            }
        }

        tableView.showsPullToRefresh = false
        SVProgressHUD.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - WhisperRequestManager delegate methods

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers newWhispers: [Whisper]) {
        SVProgressHUD.dismiss()

        tableView.infiniteScrollingView.stopAnimating()
        tableView.pullToRefreshView.stopAnimating()

        var indexPaths = [NSIndexPath]()
        for i in (whispers.count..<(whispers.count + newWhispers.count)) {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }

        whispers.extend(newWhispers)

        tableView.separatorStyle = (whispers.count > 0) ? .SingleLine : .None

        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()

        tableView.showsPullToRefresh = true
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
            let whisper = whispers[indexPath.row]
        }
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? WhispersTableViewCell {
        }
    }

}
