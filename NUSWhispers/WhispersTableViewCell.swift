//
//  WhispersTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import STTweetLabel
import SVProgressHUD

class WhispersTableViewCell: UITableViewCell, WhisperRequestManagerDelegate {
    
    @IBOutlet weak var whisperLikesCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!
    @IBOutlet weak var whisperCategoryLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperCommentsCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperContentAttributedLabel: STTweetLabel!
    
    var whispersTableViewController: WhispersTableViewController?
    
    var whisper: Whisper? {
        didSet {
            fillCellContents()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    private func fillCellContents() {
        if let whisper = whisper {
            whisperContentAttributedLabel.text = whisper.truncatedContent!
                .stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet())
            var normalAttr: [NSObject:AnyObject] = [
                NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 17)!
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
            
            whisperTagLabel.text = "#\(whisper.tag!)"
            
            whisperCategoryLabel.text = whisper.category.lowercaseString
            
            let relativeDateFormatter = NSDateFormatter()
            relativeDateFormatter.doesRelativeDateFormatting = true
            relativeDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            relativeDateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            whisperTimeLabel.text = relativeDateFormatter.stringFromDate(whisper.createdAt)
            
            whisperLikesCountLabel.text = (whisper.likesCount == 1) ? "1 like" : "\(whisper.likesCount) likes"
            
            whisperCommentsCountLabel.text = (whisper.comments.count == 1) ? "1 comment" : "\(whisper.comments.count) comments"

            contentView.needsUpdateConstraints()
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
        }
    }
    
    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whispersTableViewController?.hotWhisper = whispers.first
        whispersTableViewController?.performSegueWithIdentifier("showWhisper", sender: self)
    }
    
}
