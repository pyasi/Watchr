//
//  ViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/7/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var popularShowsCollectionView: UICollectionView!
    
    var showsToDisplay: [TVMDB] = []
    var onPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Popular"
        loadShows()
        popularShowsCollectionView.delegate = self
        popularShowsCollectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularShowsCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as! ShowCollectionCellCollectionViewCell
        cell.showTitle.text = showsToDisplay[indexPath.row].name
        cell.getImageForShow(showId: showsToDisplay[indexPath.row].id!)
        cell.numberOfSeasonsLabel.text = showsToDisplay[indexPath.row].numberOfSeasons != nil ? String(describing: showsToDisplay[indexPath.row].numberOfSeasons!) : "10"
        if (showsToDisplay[indexPath.row].numberOfSeasons == 1){
            cell.seasonLabel.text = "Season"
        }
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
    
    @IBAction func loadMoreTapped(_ sender: Any) {
        onPage += 1
        loadShows()
    }
    /*
     func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     let lastElement = showsToDisplay.count - 1
     print("shows: ", showsToDisplay)
     print("Showing: ", indexPath.row)
     if indexPath.row == lastElement {
     onPage += 1
     loadShows()
     }
     }*/
    
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
    
    func getSeasonsForShow(show: TVMDB, index: Int){
        TVDetailedMDB.tv(apiKey, tvShowID: show.id, language: "en"){
            apiReturn in
            if let data = apiReturn.1{
                show.numberOfSeasons = data.seasons.count - 1
                if (show.numberOfSeasons == 0){
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
            
        }
    }
}

