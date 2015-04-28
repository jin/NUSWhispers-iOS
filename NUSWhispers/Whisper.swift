//
//  Whisper.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

class Whisper {
    var content: String!
    var tag: Int!

    init(tag: Int, content: String) {
        self.tag = tag
        self.content = content
    }
}