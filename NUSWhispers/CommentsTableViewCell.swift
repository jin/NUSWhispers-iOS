//
//  CommentsTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 9/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    var comment: Comment? {
        didSet {
            fillCellContents()
        }
    }

    @IBOutlet weak var commentAuthorNameLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: UILabel!
    @IBOutlet weak var commentAuthorImageView: UIImageView!
    @IBOutlet weak var commentDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func fillCellContents() {
        commentAuthorNameLabel.text = comment?.authorName
        commentMessageLabel.text = comment?.message
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
