//
//  WatchrListPopupViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/30/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

enum UnwindFromPopupDestination: String{
    case ShowCollectionViewController = "unwindToShowCollection"
    case SearchViewController = "unwindToSearchController"
}

class WatchrListPopupViewController: UIViewController {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var watchListButton: DOFavoriteButton!
    @IBOutlet var watchingButton: DOFavoriteButton!
    @IBOutlet var watchedButton: DOFavoriteButton!
    @IBOutlet var cancelButton: UIButton!
    
    var showWatchrStatus: WatchrShowStatus?
    var showId: Int?
    var unwindDestination: UnwindFromPopupDestination?
    
    var watchrStatusDelegate: WatchrStatusProtocol = WatchrStatusDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
        layoutCancelButton()
        showWatchrStatus = getStatusForShowId(showId: showId!)
        setSelectedButtonWhereAppropriate()
    }
    
    func layoutCancelButton(){
        let maskPAth1 = UIBezierPath(roundedRect: cancelButton.bounds,
                                     byRoundingCorners: [.bottomLeft, .bottomRight],
                                     cornerRadii:CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = cancelButton.bounds
        maskLayer1.path = maskPAth1.cgPath
        cancelButton.layer.mask = maskLayer1
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer1.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = cancelButton.bounds
        cancelButton.layer.addSublayer(borderLayer)
    }
    
    func setSelectedButtonWhereAppropriate(){
        switch showWatchrStatus!{
        case .Watched:
            watchedButton.isSelected = true
        case .Watching:
            watchingButton.isSelected = true
        case .WatchList:
            watchListButton.isSelected = true
        case .NotWatched:
            break
        }
    }
    
    @IBAction func watchlistTapped(_ sender: DOFavoriteButton) {
        
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: showId!)
        } else {
            watchrStatusDelegate.addShowToWatchList(showId: showId!)
            self.view.isUserInteractionEnabled = false
            sender.select()
            watchingButton.deselect()
            watchedButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            dismissAfterAnimation()
        }
    }
    
    @IBAction func watchingTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: showId!)
        } else {
            watchrStatusDelegate.addShowToWatchingNow(showId: showId!)
            self.view.isUserInteractionEnabled = false
            sender.select()
            watchedButton.deselect()
            watchListButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            dismissAfterAnimation()
        }
    }
    
    @IBAction func watchedTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: showId!)
        } else {
            watchrStatusDelegate.addShowToWatched(showId: showId!)
            self.view.isUserInteractionEnabled = false
            sender.select()
            watchingButton.deselect()
            watchListButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            dismissAfterAnimation()
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.performSegue(withIdentifier: unwindDestination!.rawValue, sender: nil)
    }
    
    func dismissAfterAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.performSegue(withIdentifier: self.unwindDestination!.rawValue, sender: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
