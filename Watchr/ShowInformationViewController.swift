//
//  ShowInformationViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ShowInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var networkLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var recommendationCollectionView: UICollectionView!
    
    var show: TVMDB?
    var detailedShow: TVDetailedMDB?
    var recommendations: [TVMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShowDetailedInformation(show: show!)
        getRecommendationsForShow(show: show!)
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func loadShowInformation(){
        
        yearLabel.text = detailedShow!.first_air_date
        genreLabel.text = getGenresString(show: detailedShow!)
        networkLabel.text = detailedShow!.networks[0].name
        descriptionTextView.text = detailedShow!.overview
        descriptionTextView.sizeToFit()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        cell.showTitle.text = recommendations[indexPath.row].name
        cell.getImageForShow(showId: recommendations[indexPath.row].id!)
        
        return cell
    }
    
    func getRecommendationsForShow(show: TVMDB){
        TVMDB.similar(apiKey, tvShowID: show.id, page: 1, language: "en"){
            apiReturn in
            let shows = apiReturn.1!
            for show in shows{
                self.recommendations.append(show)
            }
            self.recommendationCollectionView.reloadData()
        }
    }
    
    func getGenresString(show: TVMDB) -> String{
        var genreString = ""
        print(show.genres)
        for x in 0...show.genres.count - 1{
            genreString.append(show.genres[x].name!)
            if(x != show.genres.count - 1){
                genreString.append(", ")
            }
        }
        return genreString
    }
    
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
    }
    
    func getShowDetailedInformation(show: TVMDB){
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            self.detailedShow = apiReturn.1!
            self.loadShowInformation()
    }
    }
}
