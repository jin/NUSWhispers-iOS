//
//  File.swift
//  NUSWhispers
//
//  Created by jin on 30/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

enum Category : String, Printable {
    case Advice = "advice"
    case Funny = "funny"
    case LostAndFound = "lost and found"
    case Nostalgia = "nostalgia"
    case Rant = "rant"
    case Romance = "romance"

    var description: String {
        return self.rawValue
    }

    var apiEndpoint: String {
        switch self {
        case .Advice:
            return ""
        case .Funny:
            return "recent"
        case .LostAndFound:
            return "popular"
        case .Nostalgia:
            return ""
        case .Rant:
            return ""
        case .Romance:
            return ""
        default:
            assertionFailure("Invalid section")
        }
    }
}