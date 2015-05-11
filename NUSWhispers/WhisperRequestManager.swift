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
        let url = "http://nuswhispers.com/api/confessions/\(tag)"
        makeGetRequest(url)
    }

    func requestForWhispers(section: Section, offset: Int = 0) {
        let url = "http://nuswhispers.com/api/confessions/\(section.apiEndpoint)?count=\(whisperCountPerRequest)&offset=\(offset)"
        makeGetRequest(url)
    }

    private func makeGetRequest(urlString: String) {
        let req = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        req.HTTPBody = nil
        req.HTTPMethod = "GET"
        req.addValue("0", forHTTPHeaderField: "Content-Length")
        requestManager!.request(req).responseJSON { (req, resp, json, error) in
            if let e = error {
                println(e)
            } else {
                self.updateWhisperDataSource(JSON(json!))
            }
        }
    }

    private func updateWhisperDataSource(json: JSON) {
        var allWhispers = [Whisper]()
        if let resp = json["data"]["confessions"].array {
            for whisper in resp {
                allWhispers.append(Whisper(json: whisper))
            }
            delegate?.whisperRequestManager(self, didReceiveWhispers: allWhispers)
        } else {
            let whisper = Whisper(json: json["data"]["confession"])
            if whisper.tag != nil {
                delegate?.whisperRequestManager(self, didReceiveWhispers: [whisper])
            }
        }
    }

}