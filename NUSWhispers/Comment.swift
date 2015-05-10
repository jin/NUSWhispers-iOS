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

    init() {

    }

    init(json: JSON) {
        authorID = json["from"]["id"].string
        authorName = json["from"]["name"].string
        commentID = json["id"].string
        message = json["message"].string
    }

}