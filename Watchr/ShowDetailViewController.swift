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
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stillsImageView: UIImageView!
    @IBOutlet var showInfoView: UIView!
    @IBOutlet var castInfoView: UIView!
    @IBOutlet var segmentControl: SWSegmentedControl!
    
    var show: TVMDB?
    var stills: [UIImage] = []
    var castController: CastCollectionViewController?
    var infoController: ShowInformationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.title = show?.name
        fillBannerImage()
        //getStillsForShow()
        castInfoView.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = whiteTheme
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillBannerImage(){
        if let path = show?.backdrop_path{
            let url = URL(string:"https://image.tmdb.org/t/p/w500_and_h281_bestv2/" + path)
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
            castInfoView.isHidden = true
            resizeScrollView()
        case 1:
            showInfoView.isHidden = true
            castInfoView.isHidden = false
            castController?.resizeCollectionView()
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination  as? ShowInformationViewController{
            infoController = destinationVC
            destinationVC.show = show
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
    
    @IBAction func watchlistButtonTapped(_ sender: DOFavoriteButton) {
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
    
    @IBAction func watchingButtonTapped(_ sender: DOFavoriteButton) {
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
    
    @IBAction func watchedButtonTapped(_ sender: DOFavoriteButton) {
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
    
    @IBAction func experimentalButtonTapped(_ sender: Any) {
        fillStillsImageView(newStills: stills)
    }
}
