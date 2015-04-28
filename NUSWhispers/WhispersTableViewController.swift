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

class WhispersTableViewController: UITableViewController {

    var requestManager: Alamofire.Manager?

    var section: Section? = .None {
        willSet {
            if let manager = requestManager {
                requestForWhispers(newValue!)
            }
        }
    }

    var whispers: [Whisper] = [Whisper]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 30
        self.requestManager = Alamofire.Manager(configuration: config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.whisperContentTextView.text = whispers[indexPath.row].content
        cell.whisperTagLabel.text = "\(whispers[indexPath.row].tag)"
        return cell
    }

    // MARK: - HTTP

    private func requestForWhispers(section: Section) {
        let baseURL = "http://nuswhispers.com/api/confessions/1505"
        println("sending get req")
        let req = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
        req.HTTPBody = nil
        req.addValue("0", forHTTPHeaderField: "Content-Length")
        req.HTTPMethod = "GET"
        requestManager!.request(req).responseJSON { (req, resp, json, error) in
            if let e = error {
                println(e)
            } else {
                self.updateWhisperDataSource(JSON(json!))
            }
        }
    }

    private func updateWhisperDataSource(json: JSON) {
        let content = json["data"]["confession"]["content"].string
        let tag = json["data"]["confession"]["confession_id"].int
        whispers = [Whisper(tag: tag!, content: content!)]
        tableView.reloadData()
    }

}
