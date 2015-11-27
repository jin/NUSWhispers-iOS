//
//  Section.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

enum Section : String, CustomStringConvertible {
    case Featured = "featured"
    case Popular = "popular"
    case Latest = "latest"

    case Advice = "advice"
    case Funny = "funny"
    case LostAndFound = "lost and found"
    case Nostalgia = "nostalgia"
    case Rant = "rant"
    case Romance = "romance"

    case NewConfession = "new confession"

    var description: String {
        return self.rawValue
    }

    var apiEndpoint: String {
        switch self {
        case .Featured:
            return ""
        case .Latest:
            return "recent"
        case .Popular:
            return "popular"
        case .Advice:
            return "category/10"
        case .Funny:
            return "category/5"
        case .LostAndFound:
            return "category/6"
        case .Nostalgia:
            return "category/9"
        case .Rant:
            return "category/8"
        case .Romance:
            return "category/7"
        case .NewConfession:
            return ""
        default:
            assertionFailure("Invalid section")
        }
    }
    
    var iconFont: String {
        switch self {
        case .Featured:
            return "pin-outline"
        case .Latest:
            return "starburst"
        case .Popular:
            return "chart-line"
//        case .Favourites:
//            return "star-full-outline"
        default:
            return ""
        }
    }
}