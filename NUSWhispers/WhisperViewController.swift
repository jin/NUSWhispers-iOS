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

    var whisper: Whisper?

    override func viewDidLoad() {
        super.viewDidLoad()
        whisperContentAttributedLabel.text = whisper?.content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonWasPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCommentsTable" {
            let destinationViewController = segue.destinationViewController as! CommentsTableViewController
            destinationViewController.comments = whisper?.comments
        }
    }

}
