//
//  WatchrStatusDelegate.swift
//  Watchr
//
//  Created by Peter Yasi on 8/30/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import Foundation
import TMDBSwift
import FirebaseDatabase

protocol WatchrStatusProtocol{
    func addShowToWatchList(showId: Int)
    func addShowToWatchingNow(showId: Int)
    func addShowToWatched(showId: Int)
}

class WatchrStatusDelegate{
    
    func addShowToWatchList(showId: Int){
        
        ref.child("watchList").child(currentUser!.watchListKey!).childByAutoId().setValue(showId)
        currentUser?.watchList.append(showId)
        removeWhereNecessary(newStatus: .WatchList, showId: showId)
    }
    
    func addToWatchingNow(showId: Int){
        ref.child("watchingNow").child(currentUser!.watchingNowKey!).childByAutoId().setValue(showId)
        currentUser?.watching.append(showId)
        removeWhereNecessary(newStatus: .Watching, showId: showId)
    }
    
    func addToWatched(showId: Int){
        ref.child("watched").child(currentUser!.watchedKey!).childByAutoId().setValue(showId)
        currentUser?.watched.append(showId)
        removeWhereNecessary(newStatus: .Watched, showId: showId)
    }
    
    func removeWhereNecessary(newStatus: WatchrShowStatus, showId: Int){
        switch newStatus{
        case .Watched:
            removeFromWatchList(showId: showId)
            removeFromWatchingNow(showId: showId)
            currentUser?.watching = (currentUser?.watching.filter({$0 != showId}))!
            currentUser?.watchList = (currentUser?.watchList.filter({$0 != showId}))!
        case .Watching:
            removeFromWatchList(showId: showId)
            removeFromWatched(showId: showId)
            currentUser?.watched = (currentUser?.watched.filter({$0 != showId}))!
            currentUser?.watchList = (currentUser?.watchList.filter({$0 != showId}))!
        case .WatchList:
            removeFromWatched(showId: showId)
            removeFromWatchingNow(showId: showId)
            currentUser?.watching = (currentUser?.watching.filter({$0 != showId}))!
            currentUser?.watched = (currentUser?.watched.filter({$0 != showId}))!
        case .NotWatched:
            removeFromWatched(showId: showId)
            removeFromWatchingNow(showId: showId)
            removeFromWatched(showId: showId)
            currentUser?.watching = (currentUser?.watching.filter({$0 != showId}))!
            currentUser?.watched = (currentUser?.watched.filter({$0 != showId}))!
            currentUser?.watchList = (currentUser?.watchList.filter({$0 != showId}))!
            break
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: showStatusListsChanged), object: nil)
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
    
}
