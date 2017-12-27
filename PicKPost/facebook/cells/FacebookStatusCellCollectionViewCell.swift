//
//  FacebookStatusCellCollectionViewCell.swift
//  PicKPost
//
//  Created by IBAdmin on 08/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//
//https://medium.com/@wasinwiwongsak/uicollectionview-with-autosizing-cell-using-autolayout-in-ios-9-10-84ab5cdf35a2


import UIKit

class FacebookStatusCellCollectionViewCell: UICollectionViewCell
{

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    @IBOutlet weak var timeOfPost: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var uoploadedImageView: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
       
        let screenwidth = UIScreen.main.bounds.size.width
       // print("Screen Width \(screenwidth)")
        //print("Screen differec \(screenwidth - (2 * 20))")
        widthConstraints.constant =  screenwidth
        
        
       
    }

}
