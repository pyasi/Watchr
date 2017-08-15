//
//  User.swift
//  Watchr
//
//  Created by Peter Yasi on 7/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class AppUser{
    
    let userId: String
    var displayName: String?
    var email: String?
    var prefferedCategories: [String]?
    var watchedKey: String?
    var watchListKey: String?
    var watchingNowKey: String?
    
    
    // In App Show Id Lists
    var watched: [Int] = []
    var watching: [Int] = []
    var watchList: [Int] = []

    
    init(user: User){
        self.userId = user.uid
        if user.email != nil{
            self.email = user.email!
        }else{
            self.email = ""
        }
        if user.displayName != nil{
            self.displayName = user.displayName!
        }else{
            self.displayName = ""
        }
        self.watchedKey = ref.child("watched").childByAutoId().key
        self.watchListKey = ref.child("watchList").childByAutoId().key
        self.watchingNowKey = ref.child("watchingNow").childByAutoId().key

    }
    
    init(snapshot: DataSnapshot){
        let value = snapshot.value as! NSDictionary
        
        self.userId = value["uid"] as! String
        self.email = value["email"] as? String
        self.displayName = value["displayName"] as? String
        self.watchedKey = value["watchedKey"] as? String
        self.watchListKey = value["watchListKey"] as? String
        self.watchingNowKey = value["watchingNowKey"] as? String

    }
    
    func toDictionary() -> NSDictionary {
        return [
            "uid": userId,
            "email": email,
            "displayName": displayName,
            "watchedKey": watchedKey,
            "watchListKey": watchListKey,
            "watchingNowKey": watchingNowKey
        ]
    }
}
