//
//  WhisperRequestManager.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class WhisperRequestManager {

    var requestManager: Alamofire.Manager?
    var delegate: WhisperRequestManagerDelegate?

    class var sharedInstance : WhisperRequestManager {
        struct Singleton {
            static let instance = WhisperRequestManager()
        }
        return Singleton.instance
    }

    private init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 30
        self.requestManager = Alamofire.Manager(configuration: config)
    }

    func requestForWhispers(section: Section) {
        let url = "http://nuswhispers.com/api/confessions/\(section.apiEndpoint)?count=10"
        let req = NSMutableURLRequest(URL: NSURL(string: url)!)
        req.HTTPBody = nil
        req.HTTPMethod = "GET"
        req.addValue("0", forHTTPHeaderField: "Content-Length")
        SVProgressHUD.show()
        requestManager!.request(req).responseJSON { (req, resp, json, error) in
            if let e = error {
                println(e)
            } else {
                self.updateWhisperDataSource(JSON(json!))
            }
        }
    }

    private func updateWhisperDataSource(json: JSON) {
        let resp = json["data"]["confessions"].array
        var allWhispers = [Whisper]()
        if let resp = resp {
            for whisper in resp {
                let content = whisper["content"].string
                let tag = whisper["confession_id"].int
                if let tag = tag {
                    if let content = content {
                        allWhispers.append(Whisper(tag: tag, content: content))
                    }
                }
            }
            delegate?.whisperRequestManager(self, didReceiveWhispers: allWhispers)
            SVProgressHUD.dismiss()
        }
    }

}