//
//  Section.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

enum Section : String, Printable {
    case Featured = "featured"
    case Popular = "popular"
    case Latest = "latest"

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
        default:
            assertionFailure("Invalid section")
        }
    }
}