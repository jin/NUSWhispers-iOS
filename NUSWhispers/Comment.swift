//
//  Comment.swift
//  NUSWhispers
//
//  Created by jin on 10/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {

    var createdAt: NSDate!
    var authorID: String!
    var authorName: String!
    var commentID: String!
    var message: String!

    init(json: JSON) {
        authorID = json["from"]["id"].string
        authorName = json["from"]["name"].string
        commentID = json["id"].string
        message = json["message"].string

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxx"
        self.createdAt = dateFormatter.dateFromString(json["created_time"].string!)
    }

}