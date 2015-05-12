//
//  WhisperRequestManager.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KILabel
import SVProgressHUD

class WhisperRequestManager {

    var requestManager: Alamofire.Manager?
    var delegate: WhisperRequestManagerDelegate?
    let whisperCountPerRequest: Int = 25

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

    func requestForWhisper(tag: Int) {
        self.requestForWhisper(tag) { (json: JSON) in
            let whispers = self.convertJSONResponseToWhispers(json)
            self.updateWhisperDataSource(whispers)
        }
    }

    func requestForWhisper(tag: Int, completion: (json: JSON) -> ()) {
        let url = "http://nuswhispers.com/api/confessions/\(tag)"
        makeGetRequest(url, completion: completion)
    }

    func requestForWhispers(section: Section, offset: Int = 0) {
        let url = "http://nuswhispers.com/api/confessions/\(section.apiEndpoint)?count=\(whisperCountPerRequest)&offset=\(offset)"
        makeGetRequest(url) { (json: JSON) in
            let whispers = self.convertJSONResponseToWhispers(json)
            self.updateWhisperDataSource(whispers)
        }
    }

    func hashtagLinkTapHandler(delegate: WhisperRequestManagerDelegate) -> ((KILabel, String, NSRange) -> ()) {
        let handler: ((KILabel, String, NSRange) -> ()) = { (label: KILabel, string: String, range: NSRange) in
            let tag = string.substringWithRange(Range<String.Index>(start: advance(string.startIndex, 1), end: string.endIndex)).toInt()
            if let tag = tag {
                WhisperRequestManager.sharedInstance.delegate = delegate
                WhisperRequestManager.sharedInstance.requestForWhisper(tag)
                SVProgressHUD.show()
            }
        }
        return handler
    }

    func urlLinkTapHandler(delegate: WhisperRequestManagerDelegate) -> ((KILabel, String, NSRange) -> ()) {
        let handler: ((KILabel, String, NSRange) -> ()) = { (label: KILabel, string: String, range: NSRange) in
            UIApplication.sharedApplication().openURL(NSURL(string: string)!)
        }
        return handler
    }

    func requestForLeaderboard() {
        let url = "http://yangshun.im/nuswhispers-leaderboard/leaderboard/may.json"
        makeGetRequest(url) { (json: JSON) in
            println(json)
        }
    }

    private func makeGetRequest(urlString: String, completion: (json: JSON) -> ()) {
        let req = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        req.HTTPBody = nil
        req.HTTPMethod = "GET"
        req.addValue("0", forHTTPHeaderField: "Content-Length")
        requestManager!.request(req).responseJSON { (req, resp, json, error) in
            if let e = error {
                println(e)
            } else {
                completion(json: JSON(json!))
            }
        }
    }

    func convertJSONResponseToWhispers(json: JSON) -> [Whisper] {
        if let resp = json["data"]["confessions"].array {
            var allWhispers = [Whisper]()
            for whisper in resp {
                allWhispers.append(Whisper(json: whisper))
            }
            return allWhispers
        } else {
            let whisper = Whisper(json: json["data"]["confession"])
            if whisper.tag != nil {
                return [whisper]
            }

            return [Whisper]()
        }
    }

    private func updateWhisperDataSource(whispers: [Whisper]) {
            delegate?.whisperRequestManager(self, didReceiveWhispers: whispers)
    }

}