//
//  CastCollectionViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 7/8/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var castImage: UIImageView!
    @IBOutlet var actorNameLabel: UILabel!
    @IBOutlet var characterLabel: UILabel!
    @IBOutlet var showTitleLabel: UILabel!
    @IBOutlet var mainBackground: UIView!
    @IBOutlet var shadowLayer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func prepareForReuse() {
        castImage.image = nil
    }
    
    func fillCastImage(path: String){
        if let url = URL(string:"https://image.tmdb.org/t/p/w138_and_h175_bestv2" + path){
            self.castImage.sd_setShowActivityIndicatorView(true)
            self.castImage.sd_setIndicatorStyle(.whiteLarge)
            self.castImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Television Icon"))
        }
    }
}
