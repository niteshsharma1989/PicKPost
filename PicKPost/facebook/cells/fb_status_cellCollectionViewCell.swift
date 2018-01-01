//
//  fb_status_cellCollectionViewCell.swift
//  PicKPost
//
//  Created by IBAdmin on 13/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit

class fb_status_cellCollectionViewCell: UITableViewCell
{

  //  @IBOutlet weak var widthConstains: NSLayoutConstraint!
    @IBOutlet weak var timeOfPostLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var uploadedImageView: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let screenwidth = UIScreen.main.bounds.size.width
            // print("Screen Width \(screenwidth)")
            //print("Screen differec \(screenwidth - (2 * 20))")
          //  widthConstains.constant =  screenwidth
            
            
            
       
    }

}
