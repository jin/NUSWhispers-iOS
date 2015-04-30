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

    init(json: JSON) {
        self.tag = json["confession_id"].int
        self.content = json["content"].string

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdAt = dateFormatter.dateFromString(json["created_at"].string!)
        self.updatedAt = dateFormatter.dateFromString(json["status_updated_at"].string!)
        self.views = json["views"].int
    }
}