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
    @IBOutlet var darkenedView: UIView!
    
    var showsToDisplay: [TVMDB] = []
    var showsFoundInSearch: [TVMDB] = []
    var onPage = 1
    var isSearching = false
    var showListType: ShowListType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShows()
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
        
        let nibName = UINib(nibName: "ShowCard", bundle:nil)
        showsCollectionView.register(nibName, forCellWithReuseIdentifier: "ShowCell")
        
        createSearchBar()
        setupViews()
        //shouldShowBlur(shouldShow: false)
    }
    
    func setupViews(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowCollectionViewController.darkenedViewTapped))
        darkenedView.addGestureRecognizer(tap)
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search shows"
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.black
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchBar.tag = 5
        
        self.navigationItem.titleView = searchBar
    }
    
    func darkenedViewTapped(){
        self.view.viewWithTag(5)?.endEditing(true)
        //shouldShowBlur(shouldShow: false)
    }
    
    func clearSearchEntries(){
        self.showsFoundInSearch.removeAll()
        self.showsCollectionView.reloadData()
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
        return isSearching ? showsFoundInSearch.count : showsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = showsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        
        let showToCreate = isSearching ? showsFoundInSearch[indexPath.row] : showsToDisplay[indexPath.row]
        
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
        let show = isSearching ? showsFoundInSearch[indexPath.row] : showsToDisplay[indexPath.row]
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
        default:
            break
            
        }
    }
    
    func loadPopularShows(){
        TVMDB.popular(apiKey, page: onPage, language: "en"){
            apiReturn in
            let tv = apiReturn.1!
            for x in 0..<tv.count{
                self.showsToDisplay.append(tv[x])
                self.getSeasonsForShow(show: tv[x], index: x)
            }
            self.showsCollectionView.reloadData()
        }
    }
    
    func loadTopRatedShows(){
        TVMDB.toprated(apiKey, page: onPage, language: "en"){
            apiReturn in
            let tv = apiReturn.1!
            for x in 0..<tv.count{
                self.showsToDisplay.append(tv[x])
                self.getSeasonsForShow(show: tv[x], index: x)
            }
            self.showsCollectionView.reloadData()
        }
    }
    
    func loadCurrentlyAiringShows(){
        TVMDB.ontheair(apiKey, page: onPage, language: "en"){
            apiReturn in
            let tv = apiReturn.1!
            for x in 0..<tv.count{
                self.showsToDisplay.append(tv[x])
                self.getSeasonsForShow(show: tv[x], index: x)
            }
            self.showsCollectionView.reloadData()
        }
    }
    
    func searchForShowsWithQuery(query: String){
        self.showsFoundInSearch.removeAll()
        SearchMDB.tv(apiKey, query: query, page: 1, language: "en", first_air_date_year: nil){
            data, tvShows in
            if(tvShows != nil){
                let shows = tvShows!
                for x in 0..<shows.count{
                    self.showsFoundInSearch.append(shows[x])
                    //self.getSeasonsForShow(show: shows[x], index: x)
                }
                self.showsCollectionView.reloadData()
            }
            else{
                self.clearSearchEntries()
            }
        }
    }
    
    func getSeasonsForShow(show: TVMDB, index: Int){
        print("Starting: 2 - ", show.name)
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            print("Returned: 2 - ", show.name)
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

extension UISearchBar {
    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}
