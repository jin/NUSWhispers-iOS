//
//  Whisper.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import SwiftyJSON

class Whisper {
    var content: String!
    var tag: Int!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    var views: Int!
    var facebookId: String!
    var category: String! = ""
    var likesCount: Int!

    init(json: JSON) {
        self.tag = json["confession_id"].int
        self.content = json["content"].string
        self.views = json["views"].int
        self.facebookId = json["facebook_information"]["id"].string
        self.likesCount = json["fb_like_count"].int
        if let category = json["categories"].array?.first {
            self.category = category["confession_category"].string
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdAt = dateFormatter.dateFromString(json["created_at"].string!)
        self.updatedAt = dateFormatter.dateFromString(json["status_updated_at"].string!)
    }
}