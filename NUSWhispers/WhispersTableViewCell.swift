//
//  WhispersTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class WhispersTableViewCell: UITableViewCell {

    @IBOutlet weak var whisperContentAttributedLabel: TTTAttributedLabel!
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
            whisperContentAttributedLabel.text = whisper.content
                .stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet())

            whisperTagLabel.text = "#\(whisper.tag!)"

            let relativeDateFormatter = NSDateFormatter()
            relativeDateFormatter.doesRelativeDateFormatting = true
            relativeDateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            relativeDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            whisperTimeLabel.text = relativeDateFormatter.stringFromDate(whisper.createdAt)
        }
    }

    @IBAction func didTapOnViewInFacebookButton(sender: AnyObject) {
        if let facebookPostId = whisper?.facebookId {
            var url: NSURL? = nil
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://")!) {
                // No URL Scheme for page's post yet
//                url = NSURL(string: "fb://posts/\(facebookPostId)")
            } else {
//                url = NSURL(string: "https://www.facebook.com/nuswhispers/posts/\(facebookPostId)")
            }
            url = NSURL(string: "https://www.facebook.com/nuswhispers/posts/\(facebookPostId)")
            UIApplication.sharedApplication().openURL(url!)
            println(url)
        }
    }
}
