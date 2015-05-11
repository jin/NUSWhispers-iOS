//
//  WhisperViewController.swift
//  NUSWhispers
//
//  Created by jin on 10/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import STTweetLabel
import SVProgressHUD

class WhisperViewController: UIViewController, WhisperRequestManagerDelegate {

    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whisperContentAttributedLabel: FixedSTTweetLabel!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!

    var whispersTableViewController: WhispersTableViewController?

    var whisper: Whisper?

    override func viewDidLoad() {
        super.viewDidLoad()
        whisperContentAttributedLabel.userInteractionEnabled = true
        whisperContentAttributedLabel.text = whisper?.content
        var normalAttr: [NSObject:AnyObject] = [
            NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!
        ]
        whisperContentAttributedLabel.setAttributes(normalAttr)

        normalAttr.updateValue(UIColor.grayColor(), forKey: NSForegroundColorAttributeName)
        whisperContentAttributedLabel.setAttributes(normalAttr, hotWord: .Hashtag)

        whisperContentAttributedLabel.detectionBlock = { (hotWord: STTweetHotWord, string: String!, proto: String!, range: NSRange) in
            if hotWord == .Hashtag {
                WhisperRequestManager.sharedInstance.delegate = self
                let tag = string.substringWithRange(Range<String.Index>(start: advance(string.startIndex, 1), end: string.endIndex)).toInt()
                if let tag = tag {
                    WhisperRequestManager.sharedInstance.requestForWhisper(tag)
                    SVProgressHUD.show()
                }
            }
        }


        let relativeDateFormatter = NSDateFormatter()
        relativeDateFormatter.doesRelativeDateFormatting = true
        relativeDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        relativeDateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if let whisper = whisper {
            whisperTagLabel.text = "#\(whisper.tag!)"
            whisperTimeLabel.text = relativeDateFormatter.stringFromDate(whisper.createdAt)
        }
        view.needsUpdateConstraints()
        view.layoutIfNeeded()
    }

    override func viewDidAppear(animated: Bool) {
        view.needsUpdateConstraints()
    }

    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCommentsTable" {
            let destinationViewController = segue.destinationViewController as! CommentsTableViewController
            destinationViewController.comments = whisper?.comments
            destinationViewController.whisperViewController = self
        }
    }

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whispersTableViewController?.hotWhisper = whispers.first
        whispersTableViewController?.performSegueWithIdentifier("showWhisper", sender: self)
    }

}
