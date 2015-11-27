//
//  CommentsTableViewController.swift
//  NUSWhispers
//
//  Created by jin on 8/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    var comments: [Comment]? = [Comment]()
    weak var whisperViewController: WhisperViewController?

    var actualContentSizeHeight: CGFloat! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.alwaysBounceVertical = false

        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" {
            whisperViewController?.commentsTableViewHeightConstraint.constant = tableView.contentSize.height
            whisperViewController?.view.setNeedsUpdateConstraints()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! CommentsTableViewCell
        cell.comment = comments?[indexPath.row]
        cell.whisperViewController = whisperViewController
        return cell
    }

}
