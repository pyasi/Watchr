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
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = showsToDisplay[indexPath.row]
        performSegue(withIdentifier: "ToShowDetailSegue", sender: show)
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
        TVMDB.popular(apiKey, page: 1, language: "en"){
            apiReturn in
            let tv = apiReturn.1!
            for show in tv{
                self.showsToDisplay.append(show)
            }
            self.popularShowsCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShowDetailViewController{
            let show = sender as! TVMDB
            destinationVC.show = show
            
        }
    }
}

