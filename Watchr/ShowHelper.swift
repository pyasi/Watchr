//
//  ShowHelper.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import Foundation
import TMDBSwift

func getShowStatus(show: TVMDB){
    if (currentUser != nil) {
        if (currentUser?.watched.contains(show.id!))!{
            show.watchrStatus = WatchrShowStatus.Watched
        }
        else if (currentUser?.watching.contains(show.id!))!{
            show.watchrStatus = WatchrShowStatus.Watching
        }
        else if (currentUser?.watchList.contains(show.id!))!{
            show.watchrStatus = WatchrShowStatus.WatchList
        }
        else{
            show.watchrStatus = WatchrShowStatus.NotWatched
        }
    }
}

func getStatusForShowId(showId: Int) -> WatchrShowStatus{
    if (currentUser != nil) {
        if (currentUser?.watched.contains(showId))!{
            return .Watched
        }
        else if (currentUser?.watching.contains(showId))!{
            return .Watching
        }
        else if (currentUser?.watchList.contains(showId))!{
            return .WatchList
        }
        else{
            return .NotWatched
        }
    }
    else{
        return .NotWatched
    }
}

func stringForShowStatus(show: TVMDB) -> String{
    if (show.watchrStatus != nil){
        switch show.watchrStatus!{
        case .Watched:
            return "Watched"
        case .Watching:
            return "Watching"
        case .WatchList:
            return "On Watch List"
        case .NotWatched:
            return "Unwatched"
        }
    }
    return ""
    
}
