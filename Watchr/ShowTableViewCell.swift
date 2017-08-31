//
//  ShowTableViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 8/10/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import FirebaseDatabase

class ShowTableViewCell: UITableViewCell {

    @IBOutlet var showNameLabel: UILabel!
    @IBOutlet var showGenres: UILabel!
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var watchrStatusButton: DOFavoriteButton!
    
    var showId: Int?
    var showWatchrStatus: WatchrShowStatus?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showImage.layer.masksToBounds = false
        showImage.layer.cornerRadius = 3
        showImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayExpectedViews(){
        showWatchrStatus = getStatusForShowId(showId: showId!)
        if (showWatchrStatus != nil){
            displayCorrectWatchrStatusButton()
        }
    }
    
    func displayCorrectWatchrStatusButton(){
        
        switch showWatchrStatus!{
        case .Watched:
            watchrStatusButton.image = UIImage(named: "heart")
        //watchrStatusButton.isSelected = true
        case .Watching:
            watchrStatusButton.image = UIImage(named: "eye")
        //watchrStatusButton.isSelected = true
        case .WatchList:
            watchrStatusButton.image = UIImage(named: "list")
        //watchrStatusButton.isSelected = true
        case .NotWatched:
            watchrStatusButton.image = UIImage(named: "add")
            //watchrStatusButton.isSelected = false
        }
    }

}
