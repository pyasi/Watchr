//
//  ShowDetailViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var stillsImageView: UIImageView!
    @IBOutlet var showInfoView: UIView!
    @IBOutlet var watchingButton: DOFavoriteButton!
    @IBOutlet var watchedButton: DOFavoriteButton!
    @IBOutlet var watchListButton: DOFavoriteButton!
    //    @IBOutlet var castInfoView: UIView!
    @IBOutlet var segmentControl: SWSegmentedControl!
    
    @IBOutlet var scrollView: UIScrollView!
    var show: TVMDB?
    var stills: [UIImage] = []
    var castController: CastCollectionViewController?
    var infoController: ShowInformationViewController?
    var showWatchrStatus: WatchrShowStatus?
    var watchrStatusDelegate: WatchrStatusProtocol = WatchrStatusDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.title = show?.name
        fillBannerImage()
        //getStillsForShow()
//        castInfoView.isHidden = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

        showWatchrStatus = getStatusForShowId(showId: (show?.id)!)
        setSelectedButtonWhereAppropriate()
        
        self.navigationController?.navigationBar.tintColor = whiteTheme
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillBannerImage(){
        if let path = show?.backdrop_path{
            let url = URL(string:"https://image.tmdb.org/t/p/w780/" + path)
            self.stillsImageView.sd_setShowActivityIndicatorView(true)
            self.stillsImageView.sd_setIndicatorStyle(.whiteLarge)
            self.stillsImageView.sd_setImage(with: url)
        }
    }
    
    @IBAction func showStillsTapped(_ sender: Any) {
        fillStillsImageView(newStills: stills)
    }
    func fillStillsImageView(newStills: [UIImage]){
        stillsImageView.animationImages = newStills
        stillsImageView.animationDuration = Double(stills.count * 3)
        stillsImageView.startAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            showInfoView.isHidden = false
//            castInfoView.isHidden = true
            resizeScrollView()
        case 1:
            showInfoView.isHidden = true
//            castInfoView.isHidden = false
            castController?.resizeCollectionView()
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination  as? ShowInformationViewController{
            infoController = destinationVC
            destinationVC.show = show
            destinationVC.parentScrollView = self.scrollView
            destinationVC.parentView = self.view
            print("First Frame: ", self.showInfoView.frame)
            var contentRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            for view in destinationVC.view.subviews {
                contentRect = contentRect.union(view.frame)
            }
            //self.showInfoView. = contentRect.height
            
        }
        if let destinationVC = segue.destination  as? CastCollectionViewController{
            castController = destinationVC
            destinationVC.show = show
        }
    }
    
    func resizeScrollView(){
        var contentRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        for view in self.scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        print(contentRect)
        self.scrollView.contentSize = contentRect.size
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
    
    @IBAction func watchlistButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: (show?.id)!)
        } else {
            watchrStatusDelegate.addShowToWatchList(showId:(show?.id)!)
            //self.view.isUserInteractionEnabled = false
            sender.select()
            watchingButton.deselect()
            watchedButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    @IBAction func watchingButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: (show?.id)!)
        } else {
            watchrStatusDelegate.addShowToWatchingNow(showId: (show?.id)!)
            //self.view.isUserInteractionEnabled = false
            sender.select()
            watchedButton.deselect()
            watchListButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    @IBAction func watchedButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            watchrStatusDelegate.removeWhereNecessary(newStatus: .NotWatched, showId: (show?.id)!)
        } else {
            watchrStatusDelegate.addShowToWatched(showId: (show?.id)!)
            //self.view.isUserInteractionEnabled = false
            sender.select()
            watchingButton.deselect()
            watchListButton.deselect()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    @IBAction func experimentalButtonTapped(_ sender: Any) {
        fillStillsImageView(newStills: stills)
    }
}


extension UITextView{
    
    func updateTextFont() {
        if ((self.text?.isEmpty)! || self.bounds.size.equalTo(CGSize.zero)) {
            return
        }
        
        let textViewSize = self.frame.size
        let fixedWidth = self.frame.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        
        var expectFont = self.font;
        if (expectSize.height > textViewSize.height) {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height:  CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont;
        }
    }
    
}
