//
//  WhisperRequestManagerDelegate.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

protocol WhisperRequestManagerDelegate {

    func whisperRequestManager(
        whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]
    )

}