//
//  ShowCollectionCellCollectionViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var seasonLabel: UILabel!
    @IBOutlet var numberOfSeasonsLabel: UILabel!
    
    override func prepareForReuse() {
        showImage.image = nil
        showTitle.text = nil
    }
    
    func getImageForShow(showId: Int){
        
        TVMDB.images(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            let tvImages = apiReturn.1!
            print(showId)
            
            if (tvImages.posters.count > 0) {
                let url = URL(string:"https://image.tmdb.org/t/p/w185//" + tvImages.posters[0].file_path!)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.showImage.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
    func layoutViews(){
        self.seasonLabel.layer.masksToBounds = true
        self.numberOfSeasonsLabel.layer.masksToBounds = true
        self.seasonLabel.layer.cornerRadius = 3
        self.numberOfSeasonsLabel.layer.cornerRadius = 3
    }
    
    @IBAction func favoriteTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    
}
