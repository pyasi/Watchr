//
//  ViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import Firebase
import FBSDKLoginKit
import AMScrollingNavbar

class ShowCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var showsCollectionView: UICollectionView!
    
    var showsToDisplay: [TVMDB] = []
    var onPage = 1
    var showListType: ShowListType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShows()
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
        
        let nibName = UINib(nibName: "ShowCard", bundle:nil)
        showsCollectionView.register(nibName, forCellWithReuseIdentifier: "ShowCell")
                
        if (showListType! == .Recommended){
            NotificationCenter.default.addObserver(self, selector: #selector(self.favoritesChanged), name: NSNotification.Name(rawValue: favoriteRemovedKey), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.favoritesChanged), name: NSNotification.Name(rawValue: favoriteAddedKey), object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //showsCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = showsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        
        let showToCreate = showsToDisplay[indexPath.row]
        
        cell.showTitle.text = showToCreate.name
        cell.getImageForShow(showId: showToCreate.id!)
        cell.numberOfSeasonsLabel.text = showToCreate.numberOfSeasons != nil ? String(describing: showToCreate.numberOfSeasons!) : "10"
        if (showToCreate.numberOfSeasons == 1){
            cell.seasonLabel.text = "Season"
        }
        cell.showId = showToCreate.id
        cell.favoriteButton.isSelected = favorites.contains(showToCreate.id!) ? true : false
        cell.layer.cornerRadius = 2
        cell.layoutViews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = showsToDisplay[indexPath.row]
        performSegue(withIdentifier: "ToShowDetailSegue", sender: show)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooter", for: indexPath as IndexPath) as! LoadMoreFooterView
            
            footerView.layoutView()
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height && showListType! != .Recommended) {
            onPage += 1
            loadShows()
        }
    }
    
    @IBAction func loadMoreTapped(_ sender: Any) {
        onPage += 1
        loadShows()
    }
    
    func loadShows(){
        
        switch showListType! {
        case .Popular:
            loadPopularShows()
        case .TopRated:
            loadTopRatedShows()
        case .OnTheAir:
            loadCurrentlyAiringShows()
        case .Recommended:
            loadRecommendedShows()
        }
    }
    
    func loadPopularShows(){
        TVMDB.popular(apiKey, page: onPage, language: "en"){
            apiReturn in
            if let tv = apiReturn.1{
                for x in 0..<tv.count{
                    self.showsToDisplay.append(tv[x])
                    self.getSeasonsForShow(show: tv[x], index: x)
                }
                self.showsCollectionView.reloadData()
            }
        }
    }
    
    func loadTopRatedShows(){
        TVMDB.toprated(apiKey, page: onPage, language: "en"){
            apiReturn in
            if let tv = apiReturn.1{
                for x in 0..<tv.count{
                    self.showsToDisplay.append(tv[x])
                    self.getSeasonsForShow(show: tv[x], index: x)
                }
                self.showsCollectionView.reloadData()
            }
        }
    }
    
    func loadCurrentlyAiringShows(){
        TVMDB.ontheair(apiKey, page: onPage, language: "en"){
            apiReturn in
            if let tv = apiReturn.1{
                for x in 0..<tv.count{
                    self.showsToDisplay.append(tv[x])
                    self.getSeasonsForShow(show: tv[x], index: x)
                }
                self.showsCollectionView.reloadData()
            }
        }
    }
    
    func loadRecommendedShows(){
        if (favorites.count < 1){
            /*
             TODO
             SHOW FAVORITES EMPTY STATE
             
             Maybe say we need at least 4 to make good choices?
             */
            return
        }
        
        //Divide up favorite so each gets into 40 loaded
        if (favorites.count < 40){
            let numberOfShowsForEach = 40 / favorites.count
            for favorite in favorites{
                getRecommendedShows(forShow: favorite, amountToGet: numberOfShowsForEach)
            }
        }
        else{
            
        }
    }
    
    func getRecommendedShows(forShow: Int, amountToGet: Int){
        var showsAdded = 0
        TVMDB.similar(apiKey, tvShowID: forShow, page: 1, language: "en"){
            apiReturn in
            if let shows = apiReturn.1{
                for x in 0..<shows.count{
                    if(showsAdded == amountToGet){
                        break
                    }
                    
                    // TODO make sure it doesn't add shows already added
                    if(!favorites.contains(shows[x].id!)){
                        self.showsToDisplay.append(shows[x])
                        self.getSeasonsForShow(show: shows[x], index: self.showsToDisplay.count - 1)
                        showsAdded += 1
                    }
                }
                self.showsCollectionView.reloadData()
                print("Number of recommendations: ", self.showsToDisplay.count)
            }
        }
    }
    
    func favoritesChanged(){
        self.showsToDisplay.removeAll()
        self.showsCollectionView.reloadData()
        loadShows()
    }
    
    func getSeasonsForShow(show: TVMDB, index: Int){
        //print("Starting: 2 - ", show.name)
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            //print("Returned: 2 - ", show.name)
            if let data = apiReturn.1{
                if let numberOfSeasons = data.number_of_seasons{
                    show.numberOfSeasons = numberOfSeasons
                    if (numberOfSeasons == 0){
                        show.numberOfSeasons = 1
                    }
                    let cell = self.showsCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ShowCollectionCellCollectionViewCell
                    cell?.numberOfSeasonsLabel.text = String(describing: show.numberOfSeasons!)
                    if (show.numberOfSeasons == 1){
                        cell?.seasonLabel.text = "Season"
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
        }
    }
}
