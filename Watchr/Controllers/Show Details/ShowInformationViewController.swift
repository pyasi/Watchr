//
//  ShowInformationViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    //@IBOutlet var yearLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var recommendationCollectionView: UICollectionView!
    
    @IBOutlet var recommendationsLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var show: TVMDB?
    var detailedShow: TVDetailedMDB?
    var recommendations: [TVMDB] = []
    var parentScrollView: UIScrollView?
    var parentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShowDetailedInformation(show: show!)
        getRecommendationsForShow(show: show!)
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        
        self.parentScrollView?.contentSize = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200).size
        self.preferredContentSize = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200).size
        recommendationsLabel.layer.masksToBounds = true
        recommendationsLabel.layer.cornerRadius = 4
        
    }
    
//    override func viewDidLayoutSubviews() {
//        var x:CGFloat      = self.parentView!.frame.origin.x
//        var y:CGFloat      = self.parentView!.frame.origin.y
//        var width:CGFloat  = self.parentView!.frame.width
//        var height:CGFloat = self.recommendationCollectionView.frame.height + self.recommendationCollectionView.bounds.origin.y
//        var frame:CGRect   = CGRect(x: x, y: y, width: width, height: height)
//        //self.parentView?.frame = frame
//        print(self.recommendationCollectionView.frame)
//        self.pare?.frame = CGRect(x: (self.parentScrollView?.frame.origin.x)!, y: (self.parentScrollView?.frame.origin.x)!, width: (self.parentScrollView?.frame.width)!, height: (self.recommendationCollectionView?.frame.height)! + (self.recommendationCollectionView?.frame.origin.y)!)
//        //print("new frame", frame)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadShowInformation(){
        
        if let airDate = detailedShow?.first_air_date{
            //yearLabel.text = airDate
        }
        genreLabel.text = getGenresString(show: detailedShow!)
        networkLabel.text = detailedShow!.networks.count > 0 ? detailedShow!.networks[0].name : " - "
        descriptionTextView.text = detailedShow!.overview != nil ? detailedShow!.overview : " - "
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO empty state for no recommendations
        
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Shouldn't be ShowCollectionCellCollectionViewCell
        let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! ShowRecommendationViewCell
        
        // No longer displaying show name
        //cell.showTitle.text = recommendations[indexPath.row].name != nil ? recommendations[indexPath.row].name : ""
        
        if( recommendations[indexPath.row].id != nil){
            if let path = recommendations[indexPath.row].poster_path{
                let url = URL(string: "https://image.tmdb.org/t/p/w185//" + path)
                cell.showImage.sd_setImage(with: url)
                cell.imageEmptyState.image = nil
            }
        }
        else{
            cell.showImage.image = UIImage(named: "default")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "ShowDetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController
        viewController?.show = recommendations[indexPath.row]
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
    func getRecommendationsForShow(show: TVMDB){
        TVMDB.similar(apiKey, tvShowID: show.id, page: 1, language: "en"){
            apiReturn in
            if let shows = apiReturn.1{
                for show in shows{
                    self.recommendations.append(show)
                }
                self.recommendationCollectionView.reloadData()
            }
        }
    }
    
    func getGenresString(show: TVMDB) -> String{
        var genreString = " - "
        if (show.genres.count > 0){
            genreString = ""
            for x in 0...show.genres.count - 1{
                genreString.append(show.genres[x].name!)
                if(x != show.genres.count - 1){
                    genreString.append(", ")
                }
            }
        }
        return genreString
    }
    
    /*
    func getNetworksString(show: TVMDB) -> String{
        var genreString = ""
        print(show.genres)
        for x in 0...show.genres.count - 1{
            genreString.append(show.genres[x].name!)
            if(x != show.genres.count - 1){
                genreString.append(", ")
            }
        }
        return genreString
    }*/
    
    func getShowDetailedInformation(show: TVMDB){
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            self.detailedShow = apiReturn.1!
            self.loadShowInformation()
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let textToShare = "Check out this show I found on Watchr" + show!.name
        let watcherLink = "linktowatchr.com"
        if let url = URL(string: "https://image.tmdb.org/t/p/w185//" + show!.poster_path!){
        let image = UIImageView()
        image.sd_setImage(with: url)
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, image.image, watcherLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    }
}
