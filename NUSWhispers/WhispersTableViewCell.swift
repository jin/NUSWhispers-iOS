//
//  WhispersTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import KILabel
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class WhispersTableViewCell: UITableViewCell, WhisperRequestManagerDelegate, UIPopoverControllerDelegate {
    @IBOutlet weak var whisperContentAttributedLabel: KILabel!
    @IBOutlet weak var whisperLikesCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!
    @IBOutlet weak var whisperCategoryLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperCommentsCountLabel: TTTAttributedLabel!

    weak var whispersTableViewController: WhispersTableViewController?
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var whisper: Whisper? {
        didSet {
            fillCellContents()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressOnContentLabel:")
        whisperContentAttributedLabel.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    deinit {
        whisperContentAttributedLabel.removeGestureRecognizer(longPressGestureRecognizer)
    }
    
    func longPressOnContentLabel(recognizer: UILongPressGestureRecognizer) {
        if SVProgressHUD.isVisible() || UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            return
        }

        let location = recognizer.locationInView(whisperContentAttributedLabel)
        let link = whisperContentAttributedLabel.linkAtPoint(location)

        if let link = link {
            let tag = extractTagFromHashtag(link["link"] as! String)
            SVProgressHUD.show()
            WhisperRequestManager.sharedInstance.requestForWhisper(tag) { (json: JSON) in
                SVProgressHUD.dismiss()
                let requestedWhisper = WhisperRequestManager.sharedInstance.convertJSONResponseToWhispers(json).first
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let contentViewController = storyboard.instantiateViewControllerWithIdentifier("whisperViewController") as! WhisperViewController
                contentViewController.whisper = requestedWhisper
                
                let popover = UIPopoverController(contentViewController: contentViewController)
                popover.delegate = self
                popover.popoverContentSize = CGSizeMake(500, 700)
                popover.presentPopoverFromRect(CGRectMake(location.x, location.y, 40, 40), inView: self.contentView, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
        }
    }
    
    private func fillCellContents() {
        if let whisper = whisper {
            whisperTagLabel.text = String(whisper.tag)
            whisperContentAttributedLabel.text = whisper.truncatedContent!
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            whisperContentAttributedLabel.hashtagLinkTapHandler = WhisperRequestManager.sharedInstance.hashtagLinkTapHandler(self)
            whisperContentAttributedLabel.urlLinkTapHandler = WhisperRequestManager.sharedInstance.urlLinkTapHandler(self)
            whisperCategoryLabel.text = whisper.category.lowercaseString
            whisperTimeLabel.text = convertUTCToLocalDateString(whisper.createdAt)
            if let likes = whisper.likesCount {
                whisperLikesCountLabel.text = (likes == 1) ? "1 like" : "\(likes) likes"
            }
            whisperCommentsCountLabel.text = (whisper.comments.count == 1) ? "1 comment" : "\(whisper.comments.count) comments"
        }
    }

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whispersTableViewController?.hotWhisper = whispers.first
        whispersTableViewController?.performSegueWithIdentifier("showWhisper", sender: self)
    }
    
}
