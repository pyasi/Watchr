//
//  FavoritesViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var favoritesCollectionsView: UICollectionView!
    
    var favoriteShows: [TVMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShows()
        
        favoritesCollectionsView.delegate = self
        favoritesCollectionsView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.favoriteRemoved(_:)), name: NSNotification.Name(rawValue: favoriteRemovedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.favoriteAdded), name: NSNotification.Name(rawValue: favoriteAddedKey), object: nil)
        
        let nibName = UINib(nibName: "ShowCard", bundle:nil)
        
        favoritesCollectionsView.register(nibName, forCellWithReuseIdentifier: "ShowCell")
        
        self.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(favoriteShows.count != favorites.count){
            favoriteShows.removeAll()
            loadShows()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func favoriteRemoved(_ notification: NSNotification){
        if let index = notification.userInfo?["index"] as? Int {
            print("Deleted", index)
            favoriteShows.remove(at: index)
            favoritesCollectionsView.deleteItems(at: [IndexPath(row: index, section: 0)])
            print("Delete finished")
        }
    }
    
    func favoriteAdded(){
        loadShows()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionsView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        cell.showTitle.text = favoriteShows[indexPath.row].name
        cell.getImageForShow(showId: favoriteShows[indexPath.row].id!)
        cell.numberOfSeasonsLabel.text = favoriteShows[indexPath.row].numberOfSeasons != nil ? String(describing: favoriteShows[indexPath.row].numberOfSeasons!) : "-"
        if (favoriteShows[indexPath.row].numberOfSeasons == 1){
            cell.seasonLabel.text = "Season"
        }
        cell.showId = favoriteShows[indexPath.row].id
        cell.favoriteButton.isSelected = true
        cell.layoutViews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = favoriteShows[indexPath.row]
        performSegue(withIdentifier: "FavoritesToDetail", sender: show)
    }
    
    func loadShows(){
        for showId in favorites{
            TVMDB.tv(apiKey, tvShowID: showId, language: "en"){
                apiReturn in
                if let show = apiReturn.1{
                    if (!self.showAlreadyExists(showToCheck: show)){
                        self.favoriteShows.append(show)
                        self.getSeasonsForShow(show: show, index: self.favoriteShows.count - 1)
                    }
                }
                self.favoritesCollectionsView.reloadData()
            }
        }
        if(favorites.isEmpty){
            favoritesCollectionsView.reloadData()
        }
    }
    
    func showAlreadyExists(showToCheck: TVMDB) -> Bool{
        for show in favoriteShows{
            if show.id == showToCheck.id{
                return true
            }
        }
        return false
    }
    
    func getSeasonsForShow(show: TVMDB, index: Int){
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            if let data = apiReturn.1{
                show.numberOfSeasons = data.number_of_seasons
                if (show.numberOfSeasons == 0){
                    show.numberOfSeasons = 1
                }
                let cell = self.favoritesCollectionsView.cellForItem(at: IndexPath(row: index, section: 0)) as? ShowCollectionCellCollectionViewCell
                cell?.numberOfSeasonsLabel.text = String(describing: show.numberOfSeasons!)
                if (show.numberOfSeasons == 1){
                    cell?.seasonLabel.text = "Season"
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
