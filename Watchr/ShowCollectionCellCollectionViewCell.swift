//
//  ShowCollectionCellCollectionViewCell.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import FirebaseDatabase

class ShowCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageEmptyState: UIImageView!
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var seasonLabel: UILabel!
    @IBOutlet var numberOfSeasonsLabel: UILabel!
    @IBOutlet var favoriteButton: DOFavoriteButton!
    
    var showId: Int?
    
    override func prepareForReuse() {
        //showImage.image = nil
        //imageEmptyState.image = nil
        showTitle.text = nil
        showId = nil
    }
    
    /*
    func getImageForShow(showId: Int){
        
        TVMDB.images(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            let tvImages = apiReturn.1!
            
            if (tvImages.posters.count > 0) {
                let url = URL(string:"https://image.tmdb.org/t/p/w185//" + tvImages.posters[0].file_path!)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.imageEmptyState.image = nil
                        self.showImage.image = UIImage(data: data!)
                    }
                }
            }
            else{
                self.imageEmptyState.image = UIImage(named: "Television Icon")
            }
        }
    }
    */
    
    func layoutViews(){
        self.seasonLabel.layer.masksToBounds = true
        self.numberOfSeasonsLabel.layer.masksToBounds = true
        self.seasonLabel.layer.cornerRadius = 3
        self.numberOfSeasonsLabel.layer.cornerRadius = 3
        self.showImage.layer.cornerRadius = 2
    }
    
    @IBAction func favoriteTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
            removeFromFavorites()
        } else {
            // select with animation
            sender.select()
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            addShowToFavorites()
        }
    }
    
    func addShowToFavorites(){
        ref.child("favorites").child(currentUser!.favoritesKey!).childByAutoId().setValue(self.showId)
        favorites.append(self.showId!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: favoriteAddedKey), object: nil)
    }
    
    func removeFromFavorites(){
        //print(favorites)
        ref.child("favorites").child(currentUser!.favoritesKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                if (thisChild.value as? Int == self.showId){
                    ref.child("favorites").child(currentUser!.favoritesKey!).child(thisChild.key).removeValue()
                    let indexToRemove = favorites.index(of: self.showId!)!
                    favorites.remove(at: indexToRemove)
                    let indexInfo:[String: Int] = ["index": indexToRemove]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: favoriteRemovedKey), object: indexToRemove, userInfo: indexInfo)
                }
            }
        })
    }
    
    
}
