//
//  MoreOptionsAlertViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import FirebaseDatabase

class MoreOptionsAlertViewController: UIAlertController {
    
    var showId : Int?
    weak var delegate: MoreOptionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "\n\n\n\n\n\n"
        self.message = nil
        
        configureView()
        addAppropriateActions()
    }
    
    func configureView(){
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: self.view.bounds.size.width - margin * 4.0, height: 120)
        let customView = UIView(frame: rect)
        
        customView.backgroundColor = .green
        self.view.addSubview(customView)
        
        let gotToShowDetails = UIAlertAction(title: "Go to Show Details", style: .default, handler: {(alert: UIAlertAction!) in self.goToShowDetailsClicked()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        self.addAction(gotToShowDetails)
        self.addAction(cancelAction)
    }
    
    func addAppropriateActions(){
        
        if(!(currentUser?.watched.contains(self.showId!))!){
            let addToWatched = UIAlertAction(title: "Watched", style: .default, handler: {(alert: UIAlertAction!) in self.addToWatched()})
            self.addAction(addToWatched)
        }
        
        if(!(currentUser?.watching.contains(self.showId!))!){
            let addToWatchingNowAction = UIAlertAction(title: "Watching Now", style: .default, handler: {(alert: UIAlertAction!) in self.addToWatchingNow()})
            self.addAction(addToWatchingNowAction)
        }
        
        if(!(currentUser?.watchList.contains(self.showId!))!){
            let addToWatchListAction = UIAlertAction(title: "Add to Watch List", style: .default, handler: {(alert: UIAlertAction!) in self.addShowToWatchList()})
            self.addAction(addToWatchListAction)
        }
        
    }
    
    func addShowToWatchList(){
        ref.child("watchList").child(currentUser!.watchListKey!).childByAutoId().setValue(self.showId)
        removeWhereNecessary(newStatus: .WatchList)
        currentUser?.watchList.append(self.showId!)
    }
    
    func addToWatchingNow(){
        ref.child("watchingNow").child(currentUser!.watchingNowKey!).childByAutoId().setValue(self.showId)
        removeWhereNecessary(newStatus: .Watching)
        currentUser?.watching.append(self.showId!)
    }
    
    func addToWatched(){
        ref.child("watched").child(currentUser!.watchedKey!).childByAutoId().setValue(self.showId)
        removeWhereNecessary(newStatus: .Watched)
        currentUser?.watched.append(self.showId!)
    }
    
    func removeWhereNecessary(newStatus: WatchrShowStatus){
        switch newStatus{
        case .Watched:
            removeFromWatchList(showId: self.showId!)
            removeFromWatchingNow(showId: self.showId!)
            currentUser?.watching = (currentUser?.watching.filter({$0 != self.showId}))!
            currentUser?.watchList = (currentUser?.watchList.filter({$0 != self.showId}))!
        case .Watching:
            removeFromWatchList(showId: self.showId!)
            removeFromWatched(showId: self.showId!)
            currentUser?.watched = (currentUser?.watched.filter({$0 != self.showId}))!
            currentUser?.watchList = (currentUser?.watchList.filter({$0 != self.showId}))!
        case .WatchList:
            removeFromWatched(showId: self.showId!)
            removeFromWatchingNow(showId: self.showId!)
            currentUser?.watching = (currentUser?.watching.filter({$0 != self.showId}))!
            currentUser?.watched = (currentUser?.watched.filter({$0 != self.showId}))!
        case .NotWatched:
            break
        }
        print("In App Watched: ", currentUser?.watched)
        print("In App Watch List: ", currentUser?.watchList)
        print("In App Watching: ", currentUser?.watching)
    }
    
    func removeFromWatched(showId: Int){
        ref.child("watched").child(currentUser!.watchedKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                if (thisChild.value as? Int == showId){
                    thisChild.ref.removeValue()
                }
            }
        })
    }
    
    func removeFromWatchList(showId: Int){
        ref.child("watchList").child(currentUser!.watchListKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                if (thisChild.value as? Int == showId){
                    thisChild.ref.removeValue()
                }
            }
        })
    }
    
    func removeFromWatchingNow(showId: Int){
        ref.child("watchingNow").child(currentUser!.watchingNowKey!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children{
                let thisChild = child as! DataSnapshot
                if (thisChild.value as? Int == showId){
                    thisChild.ref.removeValue()
                }
            }
        })
    }
    
    func goToShowDetailsClicked(){
        if((self.delegate?.responds(to: Selector(("goToShowDetailsFromOptions:")))) != nil)
        {
            self.delegate?.goToShowDetailsFromOptions(showId: self.showId!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
