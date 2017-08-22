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

class ShowCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, MoreOptionsProtocol {
    
    @IBOutlet var showsCollectionView: UICollectionView!
    
    var showsToDisplay: [TVDetailedMDB] = []
    var onPage = 1
    var showListType: ShowListType?
    var refresher: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRefreshControl()
        tryToLoadShows()
        //loadShows()
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
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(showsCollectionView, delay: 75.0, scrollSpeedFactor: 1)
        }
    }
    
    func tryToLoadShows(){
        loadWatched(completionHandler: {
            success in
            print("user is a member of a team")
            self.loadShows()
        })
    }
    
    func loadWatched(completionHandler: @escaping (Bool) -> ()){
        // TODO Clean up this logic
        ref.child("watched").child(currentUser!.watchedKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                //currentUser?.watched.append(thisChild.value as! Int)
            }
            completionHandler(true)
        })
    }
    
    func loadRefreshControl(){
        self.refresher = UIRefreshControl()
        self.refresher!.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        self.showsCollectionView!.addSubview(refresher!)
        
    }
    
    func stopRefreshing() {
        self.refresher!.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = showsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        
        let showToCreate = showsToDisplay[indexPath.row]
        getShowStatus(show: showToCreate)
        print(showToCreate.name + " - " + stringForShowStatus(show: showToCreate))
        
        cell.showId = showToCreate.id
        
        if let path = showToCreate.poster_path{
            let url = URL(string: "https://image.tmdb.org/t/p/w185//" + path)
            cell.showImage.sd_setImage(with: url)
            cell.imageEmptyState.image = nil
        }
        
        cell.showTitle.text = showToCreate.name
        
        if (showToCreate.numberOfSeasons == nil){
            cell.seasonLabel.isHidden = true
            cell.numberOfSeasonsLabel.isHidden = true
        }
        cell.numberOfSeasonsLabel.text = String(describing: showToCreate.number_of_seasons!)
        if (showToCreate.number_of_seasons == 1){
            cell.seasonLabel.text = "Season"
        }
        cell.favoriteButton.isSelected = favorites.contains(showToCreate.id!) ? true : false
        
        cell.statusIndicator.titleLabel?.text = stringForShowStatus(show: showToCreate)
        cell.statusIndicator.contentHorizontalAlignment = .left
        cell.layer.cornerRadius = 2
        cell.layoutViews()
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellToDisplay = cell as! ShowCollectionCellCollectionViewCell
        cellToDisplay.numberOfSeasonsLabel.isHidden = false
        cellToDisplay.seasonLabel.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = showsToDisplay[indexPath.row]
        performSegue(withIdentifier: "ToShowDetailSegue", sender: show)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height && showListType! != .Recommended) {
            onPage += 1
            loadShows()
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
    
    func loadMoreOptions(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
        }
    }
    
    @IBAction func loadMoreTapped(_ sender: Any) {
        onPage += 1
        loadShows()
    }
    
    func handleRefresh(){
        showsToDisplay.removeAll()
        onPage = 1
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
                for show in tv{
                    self.getShowDetails(show: show)
                }
                self.stopRefreshing()
            }
        }
    }
    
    func loadTopRatedShows(){
        TVMDB.toprated(apiKey, page: onPage, language: "en"){
            apiReturn in
            if let tv = apiReturn.1{
                for show in tv{
                    self.getShowDetails(show: show)
                }
                self.stopRefreshing()
            }
        }
    }
    
    func loadCurrentlyAiringShows(){
        TVMDB.ontheair(apiKey, page: onPage, language: "en"){
            apiReturn in
            if let tv = apiReturn.1{
                for show in tv{
                    self.getShowDetails(show: show)
                }
                self.stopRefreshing()
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
                for show in shows{
                    if(showsAdded == amountToGet){
                        break
                    }
                    
                    // TODO make sure it doesn't add shows already added
                    if(!favorites.contains(show.id!)){
                        self.getShowDetails(show: show)
                        showsAdded += 1
                    }
                }
                self.stopRefreshing()
                print("Number of recommendations: ", self.showsToDisplay.count)
            }
        }
    }
    
    func favoritesChanged(){
        self.showsToDisplay.removeAll()
        self.showsCollectionView.reloadData()
        loadShows()
    }
    
    func getShowDetails(show: TVMDB){
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            if let show = apiReturn.1{
                self.showsToDisplay.append(show)
                self.showsCollectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
        }
    }
    
    func goToShowDetailsFromOptions(showId: Int){
        
        TVMDB.tv(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            if let show = apiReturn.1{
                self.performSegue(withIdentifier: "ToShowDetailSegue", sender: show)
            }
        }
    }
}
