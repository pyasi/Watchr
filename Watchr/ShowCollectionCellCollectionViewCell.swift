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

protocol MoreOptionsProtocol : NSObjectProtocol {
    func loadMoreOptions(controller: UIViewController) -> Void
    func goToShowDetailsFromOptions(showId: Int)
}

class ShowCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageEmptyState: UIImageView!
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var seasonLabel: UILabel!
    @IBOutlet var numberOfSeasonsLabel: UILabel!
    @IBOutlet var favoriteButton: DOFavoriteButton!
    @IBOutlet var optionsMenuButton: UIButton!
    @IBOutlet var statusIndicator: UIButton!
    
    var showId: Int?
    weak var delegate: MoreOptionsProtocol?
    
    override func prepareForReuse() {
        showTitle.text = nil
        showId = nil
        numberOfSeasonsLabel.isHidden = false
        seasonLabel.isHidden = false
    }
    
    func layoutViews(){
        self.seasonLabel.layer.masksToBounds = true
        self.numberOfSeasonsLabel.layer.masksToBounds = true
        self.seasonLabel.layer.cornerRadius = 3
        self.numberOfSeasonsLabel.layer.cornerRadius = 3
        self.showImage.layer.cornerRadius = 2
    }
    
    @IBAction func optionsMenuButtonTapped(_ sender: Any) {
        let alertController = MoreOptionsAlertViewController()
        alertController.showId = self.showId!
        alertController.delegate = self.delegate
        
        DispatchQueue.main.async {
            if((self.delegate?.responds(to: Selector(("loadMoreOptions:")))) != nil)
            {
                self.delegate?.loadMoreOptions(controller: alertController)
            }
        }
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
        ref.child("watched").child(currentUser!.watchedKey!).childByAutoId().setValue(self.showId)
        favorites.append(self.showId!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: favoriteAddedKey), object: nil)
    }
    
    func removeFromFavorites(){
        
        ref.child("watched").child(currentUser!.watchedKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                if (thisChild.value as? Int == self.showId){
                    ref.child("watched").child(currentUser!.watchedKey!).child(thisChild.key).removeValue()
                    let indexToRemove = favorites.index(of: self.showId!)!
                    favorites.remove(at: indexToRemove)
                    let indexInfo:[String: Int] = ["index": indexToRemove]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: favoriteRemovedKey), object: indexToRemove, userInfo: indexInfo)
                }
            }
        })
    }
}
