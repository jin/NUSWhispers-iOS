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
    var cellContentTextViews: [NSIndexPath:UITextView] = [NSIndexPath:UITextView]()

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
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return whispers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! WhispersTableViewCell
        cell.whisperContentTextView.text = whispers[indexPath.row].content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        cell.whisperTagLabel.text = "\(whispers[indexPath.row].tag)"

        cellContentTextViews[indexPath] = cell.whisperContentTextView
        return cell
    }

}
