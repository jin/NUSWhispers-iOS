//
//  CommentsTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 9/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import KILabel
import SVProgressHUD
import SwiftyJSON

class CommentsTableViewCell: UITableViewCell, WhisperRequestManagerDelegate, UIPopoverControllerDelegate {

    @IBOutlet weak var commentAuthorNameLabel: UILabel!
    @IBOutlet weak var commentAuthorImageView: UIImageView!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: KILabel!

    weak var whisperViewController: WhisperViewController?

    var comment: Comment? {
        didSet {
            fillCellContents()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = UITableViewCellSelectionStyle.None

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressOnContentLabel:")
        commentMessageLabel.addGestureRecognizer(longPressGestureRecognizer)
    }

    private func fillCellContents() {
        commentDateLabel.text = convertDateToString(comment!.createdAt)
        commentAuthorNameLabel.text = comment?.authorName
        commentMessageLabel.text = comment?.message
        commentMessageLabel.hashtagLinkTapHandler = WhisperRequestManager.sharedInstance.hashtagLinkTapHandler(self)
        commentMessageLabel.urlLinkTapHandler = WhisperRequestManager.sharedInstance.urlLinkTapHandler(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whisperViewController?.pushAndLoadWhisper(whispers.first!)
    }

    func longPressOnContentLabel(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.locationInView(commentMessageLabel)
        let link = commentMessageLabel.linkAtPoint(location)
        if let link = link where UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let tag = extractTagFromHashtag(link["link"] as! String)

            if !SVProgressHUD.isVisible() {
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
    }

}
