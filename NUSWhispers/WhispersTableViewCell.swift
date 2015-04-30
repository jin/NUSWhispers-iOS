//
//  WhispersTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class WhispersTableViewCell: UITableViewCell {

    @IBOutlet weak var whisperContentTextView: UITextView!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!

    var whisper: Whisper? {
        didSet {
            fillCellContents()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func fillCellContents() {
        if let whisper = whisper {
            whisperContentTextView.text = whisper.content
                .stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet())
            whisperTagLabel.text = "#\(whisper.tag!)"
        }
    }

    @IBAction func didTapOnViewInFacebookButton(sender: AnyObject) {
    }
}
