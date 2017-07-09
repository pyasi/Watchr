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
        
        cell.mainBackground.layer.cornerRadius = 5
        cell.mainBackground.layer.masksToBounds = true
        
        cell.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        cell.shadowLayer.layer.shadowOpacity = 0.75
        cell.shadowLayer.layer.shadowRadius = 3
        cell.shadowLayer.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        cell.shadowLayer.layer.shouldRasterize = true
        cell.shadowLayer.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actor = castMembers[indexPath.row]
        performSegue(withIdentifier: "CastToActorDetailSegue", sender: actor)
    }
    
    func resizeCollectionView(){
        if let parent = self.parent as? ShowDetailViewController{
            parent.scrollView.contentSize.height = self.castCollectionView.contentSize.height + 225
            castCollectionView.frame = CGRect(x: 0, y: 0, width: self.castCollectionView.contentSize.width, height: self.castCollectionView.contentSize.height + 225)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ActorDetailViewController{
            destinationVC.actorId = (sender as? TVCastMDB)?.id
        }
    }
}
