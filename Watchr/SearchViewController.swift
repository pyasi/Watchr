//
//  SearchViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/10/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchTableView: UITableView!
    
    var showsFoundInSearch: [TVMDB] = []
    var isSearching = false
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        setupNavBar()
    }
    
    func setupNavBar(){
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search shows"
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.black
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchBar.tag = 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.searchBar.becomeFirstResponder()
        })
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = searchBar.text != "" ? true : false
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchTableView.isScrollEnabled = false
        searchTableView.isScrollEnabled = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        clearSearchEntries()
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if (!searchBar.text!.isEmpty){
            //popularShowsCollectionView.setContentOffset(CGPoint.zero, animated: false)
            searchForShowsWithQuery(query: searchBar.text!)
        }
        else{
            clearSearchEntries()
            /*
             ***
             Collection view empty state
             ***
             */
        }
    }
    
    func clearSearchEntries(){
        self.showsFoundInSearch.removeAll()
        self.searchTableView.reloadData()
    }
    
    func searchForShowsWithQuery(query: String){
        self.showsFoundInSearch.removeAll()
        SearchMDB.tv(apiKey, query: query, page: 1, language: "en", first_air_date_year: nil){
            data, tvShows in
            if(tvShows != nil){
                let shows = tvShows!
                for x in 0..<shows.count{
                    self.showsFoundInSearch.append(shows[x])
                    //self.getDetailedShow(show: shows[x])
                }
                self.searchTableView.reloadData()
            }
            else{
                self.clearSearchEntries()
            }
        }
    }
    
    func getDetailedShow(show: TVMDB){
        
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            if let data = apiReturn.1{
                if (data.name != nil){
                    self.showsFoundInSearch.append(data)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsFoundInSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "ShowTableCell", for: indexPath) as! ShowTableViewCell
        
        let show = showsFoundInSearch[indexPath.row]
        
        cell.showNameLabel.text = show.name
        
        if let path = show.poster_path{
            let url = URL(string: "https://image.tmdb.org/t/p/w92/" + path)
            cell.showImage.sd_setImage(with: url)
        }
        //cell.showImage.image
        
        var genreString = ""
        for x in 0..<show.genres.count{
            genreString = genreString + "\(String(describing: show.genres[x].name!))"
            if (x == show.genres.count - 1){
                break
            }
            else{
                genreString = genreString + ", "
            }
        }
        cell.showGenres.text = genreString
        
        cell.showId = show.id
        cell.displayExpectedViews()
        //cell.favoriteButton.isSelected = favorites.contains(show.id!) ? true : false
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = showsFoundInSearch[indexPath.row]
        searchBar.endEditing(true)
        performSegue(withIdentifier: "SearchToShotDetailSegue", sender: show)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
