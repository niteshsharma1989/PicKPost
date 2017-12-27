//
//  PhotosCell.swift
//  PicKPost
//
//  Created by IBAdmin on 31/10/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell
{

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var representedAssetIdentifier : String?
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickImageShare(_ sender: Any)
    {
        
    }
}
