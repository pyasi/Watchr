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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var popularShowsCollectionView: UICollectionView!
    @IBOutlet var darkenedView: UIView!
    
    var showsToDisplay: [TVMDB] = []
    var showsFoundInSearch: [TVMDB] = []
    var onPage = 1
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShows()
        popularShowsCollectionView.delegate = self
        popularShowsCollectionView.dataSource = self
        
        let nibName = UINib(nibName: "ShowCard", bundle:nil)
        popularShowsCollectionView.register(nibName, forCellWithReuseIdentifier: "ShowCell")
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(popularShowsCollectionView, delay: 50.0)
        }
        
        createSearchBar()
        shouldShowBlur(shouldShow: false)
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search shows"
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.black
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = searchBar.text != "" ? true : false
        if (!isSearching){
            searchBar.showsCancelButton = false
            self.popularShowsCollectionView.reloadData()
        }
        shouldShowBlur(shouldShow: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shouldShowBlur(shouldShow: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if (!searchBar.text!.isEmpty){
            shouldShowBlur(shouldShow: false)
            searchForShowsWithQuery(query: searchBar.text!)
        }
        else{
            shouldShowBlur(shouldShow: true)
            /*
             ***
             Collection view empty state
             ***
             */
        }
    }
    
    func shouldShowBlur(shouldShow: Bool){
        if(shouldShow){
            popularShowsCollectionView.addSubview(darkenedView)
        }
        else{
            darkenedView.removeFromSuperview()
        }
    }
    
    func clearSearchEntries(){
        self.showsFoundInSearch.removeAll()
        self.popularShowsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        popularShowsCollectionView.reloadData()
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
    
    // Nav Bar
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? showsFoundInSearch.count : showsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularShowsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        
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
        TVMDB.popular(apiKey, page: onPage, language: "en"){
            apiReturn in
            let tv = apiReturn.1!
            for x in 0..<tv.count{
                self.showsToDisplay.append(tv[x])
                self.getSeasonsForShow(show: tv[x], index: x)
            }
            self.popularShowsCollectionView.reloadData()
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
                self.popularShowsCollectionView.reloadData()
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
                    let cell = self.popularShowsCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? ShowCollectionCellCollectionViewCell
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
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.performSegue(withIdentifier: "LogOutSegue", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
