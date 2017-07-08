//
//  CastCollectionViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/8/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class CastCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var castCollectionView: UICollectionView!
    
    var show: TVMDB?
    var castMembers: [TVCastMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        getCastForShow(show: show!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCollectionViewCell
        cell.actorNameLabel.text = castMembers[indexPath.row].name
        cell.characterLabel.text = castMembers[indexPath.row].character
        cell.fillCastImage(path: castMembers[indexPath.row].profile_path!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func resizeCollectionView(){
        if let parent = self.parent as? ShowDetailViewController{
            parent.scrollView.contentSize.height = self.castCollectionView.contentSize.height + 225
            castCollectionView.frame = CGRect(x: 0, y: 0, width: self.castCollectionView.contentSize.width, height: self.castCollectionView.contentSize.height + (self.tabBarController?.tabBar.frame.height)! + 225)
            castCollectionView.reloadData()
        }
    }

    func getCastForShow(show: TVMDB){
        TVMDB.credits(apiKey, tvShowID: show.id){
            apiReturn in
            if let castCrew = apiReturn.1{
                for cast in castCrew.cast{
                    self.castMembers.append(cast)
                }
                self.castCollectionView.reloadData()
            }
        }
    }
}
