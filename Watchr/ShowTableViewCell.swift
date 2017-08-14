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
    @IBOutlet var favoriteButton: DOFavoriteButton!
    
    var showId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showImage.layer.cornerRadius = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
