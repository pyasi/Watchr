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
    
    func fillCastImage(path: String){
            let url = URL(string:"https://image.tmdb.org/t/p/w185//" + path)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.castImage.image = UIImage(data: data!)
                }
        }
    }
}
