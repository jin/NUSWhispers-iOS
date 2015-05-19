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
    var imageURL: NSURL!
    var image: UIImage!

    var comments: [Comment]! = [Comment]()

    var truncatedContent: String? {
        var truncated = content as NSString
        if truncated.length > 400 {
            truncated = truncated.substringToIndex(400)
            return (truncated as String).stringByAppendingString("...")
        } else {
            return content
        }
    }

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
        if let createdAtString = json["created_at"].string {
            self.createdAt = dateFormatter.dateFromString(createdAtString)
        }

        if let updatedAtString = json["status_updated_at"].string {
            self.updatedAt = dateFormatter.dateFromString(updatedAtString)
        }

        self.comments = json["facebook_information"]["comments"]["data"].array?.map({
            Comment(json: $0)
        })

//        if let url = json["images"].string {
            self.imageURL = NSURL(string: "http://fakeimg.pl/650x600/")
//        }

//        if let imageURL = json["images"].string {
//            self.imageURL = NSURL(string: imageURL)
//            if let data = NSData(contentsOfURL: self.imageURL) {
//                self.image = UIImage(data: data)
//            }
//        }
    }
}