//
//  PostCellTableViewCell.swift
//  PicKPost
//
//  Created by IBAdmin on 13/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var timeOfPostTv: UILabel!
    //@IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var uploadedImageView: UIImageView!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
