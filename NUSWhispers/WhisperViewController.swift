//
//  WhisperViewController.swift
//  NUSWhispers
//
//  Created by jin on 10/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import KILabel
import SVProgressHUD

class WhisperViewController: UIViewController, WhisperRequestManagerDelegate {

    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!
    @IBOutlet weak var whisperContentAttributedLabel: KILabel!
    @IBOutlet weak var whisperCommentsCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperLikesCountLabel: TTTAttributedLabel!

    var whispersTableViewController: WhispersTableViewController?

    var whisper: Whisper?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let whisper = whisper {
            whisperContentAttributedLabel.userInteractionEnabled = true
            whisperContentAttributedLabel.text = whisper.content
            whisperContentAttributedLabel.hashtagLinkTapHandler = WhisperRequestManager.sharedInstance.hashtagLinkTapHandler(self)
            whisperContentAttributedLabel.urlLinkTapHandler = WhisperRequestManager.sharedInstance.urlLinkTapHandler(self)
            
            let relativeDateFormatter = NSDateFormatter()
            relativeDateFormatter.doesRelativeDateFormatting = true
            relativeDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            relativeDateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            whisperTagLabel.text = "#\(whisper.tag!)"
            whisperTimeLabel.text = relativeDateFormatter.stringFromDate(whisper.createdAt)

            self.title = "#\(whisper.tag)"
            
            whisperLikesCountLabel.text = (whisper.likesCount == 1) ? "1 like" : "\(whisper.likesCount) likes"
            whisperCommentsCountLabel.text = (whisper.comments.count == 1) ? "1 comment" : "\(whisper.comments.count) comments"
            
            view.needsUpdateConstraints()
            view.layoutIfNeeded()
            
        }
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

    func pushAndLoadWhisper(whisper: Whisper) {
        whispersTableViewController?.hotWhisper = whisper
        whispersTableViewController?.performSegueWithIdentifier("showWhisper", sender: self)
    }

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        pushAndLoadWhisper(whispers.first!)
    }

}
