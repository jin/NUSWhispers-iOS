//
//  File.swift
//  NUSWhispers
//
//  Created by jin on 12/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import STTweetLabel

class FixedSTTweetLabel : STTweetLabel {

    override func intrinsicContentSize() -> CGSize {
        let size = self.suggestedFrameSizeToFitEntireStringConstrainedToWidth(self.frame.size.width)
        return CGSizeMake(size.width, size.height)
    }

}