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
import SwiftyJSON

class WhisperViewController: UIViewController, WhisperRequestManagerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!
    @IBOutlet weak var whisperContentAttributedLabel: KILabel!
    @IBOutlet weak var whisperCommentsCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperLikesCountLabel: TTTAttributedLabel!
    
    weak var whispersTableViewController: WhispersTableViewController?
    
    var whisper: Whisper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let whisper = whisper {
            whisperContentAttributedLabel.userInteractionEnabled = true
            whisperContentAttributedLabel.text = whisper.content
            whisperContentAttributedLabel.hashtagLinkTapHandler = WhisperRequestManager.sharedInstance.hashtagLinkTapHandler(self)
            whisperContentAttributedLabel.urlLinkTapHandler = WhisperRequestManager.sharedInstance.urlLinkTapHandler(self)
            
            whisperTimeLabel.text = convertUTCToLocalDateString(whisper.createdAt)
            whisperTagLabel.text = "#\(whisper.tag!)"
            whisperLikesCountLabel.text = (whisper.likesCount == 1) ?
                "1 like" : "\(whisper.likesCount) likes"
            whisperCommentsCountLabel.text = (whisper.comments.count == 1) ?
                "1 comment" : "\(whisper.comments.count) comments"
            
            self.title = "#\(whisper.tag)"
            
            view.needsUpdateConstraints()
            view.layoutIfNeeded()
        }
        
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressOnContentLabel:")
        whisperContentAttributedLabel.addGestureRecognizer(longPressGestureRecognizer)
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

    func longPressOnContentLabel(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.locationInView(whisperContentAttributedLabel)
        let link = whisperContentAttributedLabel.linkAtPoint(location)
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
                    popover.presentPopoverFromRect(CGRectMake(location.x, location.y, 40, 40), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                }
            }
        }
    }
    
}
