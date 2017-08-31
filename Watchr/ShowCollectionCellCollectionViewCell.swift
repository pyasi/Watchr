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

protocol CellActionsProtocol : NSObjectProtocol {
    func loadMoreOptions(controller: UIViewController) -> Void
    func goToShowDetailsFromOptions(showId: Int)
    func loadWatchrStatusPopup(showId: Int)
}

class ShowCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageEmptyState: UIImageView!
    @IBOutlet var showImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var seasonLabel: UILabel!
    @IBOutlet var numberOfSeasonsLabel: UILabel!
    @IBOutlet var watchrStatusButton: DOFavoriteButton!
    @IBOutlet var optionsMenuButton: UIButton!
    
    var showId: Int?
    var showWatchrStatus: WatchrShowStatus?
    weak var delegate: CellActionsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 2
        self.layoutViews()
        if let status = showWatchrStatus{
            displayCorrectWatchrStatusButton()
        }
    }
    
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
    
    func displayCorrectWatchrStatusButton(){
        switch showWatchrStatus!{
        case .Watched:
            watchrStatusButton.image = UIImage(named: "heart")
        case .Watching:
            watchrStatusButton.image = UIImage(named: "eye")
        case .WatchList:
            watchrStatusButton.image = UIImage(named: "list")
        case .NotWatched:
            watchrStatusButton.image = UIImage(named: "add")
        }
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
    
    @IBAction func changeWatchrStatusTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            if((self.delegate?.responds(to: Selector(("loadWatchrStatusPopup:")))) != nil)
            {
                self.delegate?.loadWatchrStatusPopup(showId: self.showId!)
            }
        }
    }
    
    @IBAction func favoriteTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
