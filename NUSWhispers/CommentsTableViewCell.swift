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

class CommentsTableViewCell: UITableViewCell, WhisperRequestManagerDelegate {

    @IBOutlet weak var commentAuthorNameLabel: UILabel!
    @IBOutlet weak var commentAuthorImageView: UIImageView!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: KILabel!

    var whisperViewController: WhisperViewController?

    var comment: Comment? {
        didSet {
            fillCellContents()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func fillCellContents() {
        commentAuthorNameLabel.text = comment?.authorName
        commentMessageLabel.text = comment?.message
        commentMessageLabel.hashtagLinkTapHandler = { (label: KILabel, string: String, range: NSRange) in
            WhisperRequestManager.sharedInstance.delegate = self
            let tag = string.substringWithRange(Range<String.Index>(start: advance(string.startIndex, 1), end: string.endIndex)).toInt()
            if let tag = tag {
                WhisperRequestManager.sharedInstance.delegate = self
                WhisperRequestManager.sharedInstance.requestForWhisper(tag)
                SVProgressHUD.show()
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whisperViewController?.pushAndLoadWhisper(whispers.first!)
    }

}
