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

class WhispersTableViewController: UITableViewController, WhisperRequestManagerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var section: Section? = .None {
        willSet {
            WhisperRequestManager.sharedInstance.delegate = self
            WhisperRequestManager.sharedInstance.requestForWhispers(newValue!)
        }
    }

    var whispers: [Whisper] = [Whisper]()
    var backedUpWhispersWhileSearching: [Whisper]?
    var hotWhisper: Whisper?

    var rowHeightEstimateCache = [String:CGFloat]()

    var searchController: UISearchController!
    weak var detailViewController: DetailViewController!
    var currentSearchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "handleRefresh", forControlEvents: UIControlEvents.ValueChanged)

        tableView.addInfiniteScrollingWithActionHandler {
            if let searchText = self.currentSearchText {
                WhisperRequestManager.sharedInstance.searchForWhispers(
                    searchText,
                    offset: self.whispers.count)
            } else if let section = self.section {
                WhisperRequestManager.sharedInstance.requestForWhispers(
                    section,
                    offset: self.whispers.count)
            } else {
                self.tableView.infiniteScrollingView.stopAnimating()
            }
        }

        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    override func viewDidAppear(animated: Bool) {
        if whispers.isEmpty {
            SVProgressHUD.show()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        tableView.tableHeaderView?.sizeToFit()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if whispers.isEmpty {
            if let backedUpWhispers = backedUpWhispersWhileSearching {
                whispers = backedUpWhispers
                tableView.separatorStyle = .SingleLine
                tableView.reloadData()
                setNavigationBarTitleBasedOnCurrentContext()
            }
        }
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        WhisperRequestManager.sharedInstance.delegate = self
        let text = searchController.searchBar.text
        if backedUpWhispersWhileSearching == nil {
            backedUpWhispersWhileSearching = whispers
        }
        if count(text) > 0 {
            tableView.separatorStyle = .None
            whispers.removeAll()
            tableView.reloadData()
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
            }
            WhisperRequestManager.sharedInstance.searchForWhispers(searchController.searchBar.text)
        }
    }

    func handleRefresh() {
        setNavigationBarTitleBasedOnCurrentContext()
        if let searchText = currentSearchText {
            WhisperRequestManager.sharedInstance.searchForWhispers(searchText, offset: 0)
        } else if let section = self.section {
            WhisperRequestManager.sharedInstance.requestForWhispers(section, offset: 0)
        } else {
            refreshControl?.endRefreshing()
        }
    }

    // MARK: - WhisperRequestManager delegate methods

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers newWhispers: [Whisper]) {
        SVProgressHUD.dismiss()
        tableView.infiniteScrollingView.stopAnimating()

        if let isRefreshing = refreshControl?.refreshing where isRefreshing {
            whispers.removeAll()
            tableView.reloadData()
        }

        if !newWhispers.isEmpty {
            backedUpWhispersWhileSearching = nil
            let searchText = searchController.searchBar.text
            currentSearchText = searchText.isEmpty ? nil : searchText
        }

        var indexPaths = [NSIndexPath]()
        for i in (whispers.count..<(whispers.count + newWhispers.count)) {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }

        whispers.extend(newWhispers)

        tableView.separatorStyle = (whispers.count > 0) ? .SingleLine : .None

        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(
            indexPaths,
            withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()

        setNavigationBarTitleBasedOnCurrentContext()

        refreshControl?.endRefreshing()
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
        cell.whispersTableViewController = self
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showWhisper", sender: self)
    }

    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        rowHeightEstimateCache["\(indexPath.row)"] = CGRectGetHeight(cell.frame)
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = rowHeightEstimateCache["\(indexPath.row)"] {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWhisper" {
            let destinationViewController = segue.destinationViewController as! WhisperViewController
            destinationViewController.whispersTableViewController = self
            if let whisper = hotWhisper {
                destinationViewController.whisper = whisper
            } else {
                let selectedWhisper = whispers[tableView.indexPathForSelectedRow()!.row]
                destinationViewController.whisper = selectedWhisper
            }
            hotWhisper = nil
        }
    }

    private func setNavigationBarTitleBasedOnCurrentContext() {
        if let searchText = currentSearchText {
            detailViewController.navigationItem.title = "Results for \"\(searchText)\""
        } else {
            detailViewController.navigationItem.title = section?.description.capitalizedString
        }
    }

}