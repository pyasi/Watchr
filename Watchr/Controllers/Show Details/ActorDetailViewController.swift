//
//  ActorDetailViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/8/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift

class ActorDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var birthYearLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var biographyTextView: UITextView!
    @IBOutlet var actorsWorkCollectionView: UICollectionView!
    @IBOutlet var actorImage: UIImageView!
    
    var actorId: Int?
    var actor: PersonMDB?
    var shows: [PersonTVCast] = []
    var associatedShows: [TVMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActorDetails(actordId: actorId!)
        getActorsWork(actorId: actorId!)
        
        actorsWorkCollectionView.delegate = self
        actorsWorkCollectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDetails(actor: PersonMDB){
        birthYearLabel.text = actor.birthday
        fromLabel.text = actor.place_of_birth
        biographyTextView.text = actor.biography
        self.title = actor.name
        
    }
    
    func getActorDetails(actordId: Int){
        PersonMDB.person_id(apiKey, personID: actorId){
            data, personData in
            if let person = personData{
                self.actor = person
                self.loadDetails(actor: person)
            }
        }
    }
    
    func getActorsWork(actorId: Int){
        PersonMDB.tv_credits(apiKey, personID: actorId, language: "en"){
            data, credits in
            if let credit = credits{
                for show in credit.cast{
                    self.shows.append(show)
                }
                self.actorsWorkCollectionView.reloadData()
                for show in self.shows{
                    self.getShowFromId(showId: show.id)
                }
            }
        }
    }
    
    func getShowFromId(showId: Int){
        TVMDB.tv(apiKey, tvShowID: showId, language: "en"){
            apiReturn in
            if( apiReturn.0.error == nil){
                if let tv = apiReturn.1{
                    self.associatedShows.append(tv)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = actorsWorkCollectionView.dequeueReusableCell(withReuseIdentifier: "ActorsWorkCell", for: indexPath) as! CastCollectionViewCell
        cell.showTitleLabel.text = shows[indexPath.row].name != nil ? shows[indexPath.row].name : ""
        cell.characterLabel.text = shows[indexPath.row].character != nil ? shows[indexPath.row].character  : ""
        if(shows[indexPath.row].poster_path != nil){
            cell.fillCastImage(path: shows[indexPath.row].poster_path!)
        }
        else{
            cell.castImage.image = UIImage(named: "default")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ShowDetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController
        viewController?.show = associatedShows[indexPath.row]
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}
