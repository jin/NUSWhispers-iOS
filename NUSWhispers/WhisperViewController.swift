//
//  WhisperViewController.swift
//  NUSWhispers
//
//  Created by jin on 10/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class WhisperViewController: UIViewController {

    @IBOutlet weak var whisperContentAttributedLabel: TTTAttributedLabel!
    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!

    var whisper: Whisper?

    override func viewDidLoad() {
        super.viewDidLoad()
        whisperContentAttributedLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        whisperContentAttributedLabel.userInteractionEnabled = true
        whisperContentAttributedLabel.text = whisper?.content
    }

    override func viewDidAppear(animated: Bool) {
        setUpDismissGesture()
    }

    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setUpDismissGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: "dismissViewController:")
        recognizer.numberOfTapsRequired = 1
        recognizer.cancelsTouchesInView = false
        self.view.window?.addGestureRecognizer(recognizer)
    }

    func dismissViewController(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let location = sender.locationInView(nil)
            if self.view.pointInside(
                self.view.convertPoint(location, fromView: self.view.window), withEvent: nil) {
                    self.view.window?.removeGestureRecognizer(sender)
                    self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCommentsTable" {
            let destinationViewController = segue.destinationViewController as! CommentsTableViewController
            destinationViewController.comments = whisper?.comments
            destinationViewController.whisperViewController = self
        }
    }

}
