//
//  FriendTableViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 8/31/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet var followButton: DOFavoriteButton!
    @IBOutlet var friendNameLabel: UILabel!
    @IBOutlet var friendPicture: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
