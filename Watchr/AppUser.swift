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
    let facebookId: String?
    var displayName: String?
    var email: String?
    var photoURL: URL?
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
        self.facebookId = ""
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
        if user.photoURL != nil{
            self.photoURL = user.photoURL!
        }
        else{
            self.photoURL = URL(string: "")
        }
        self.watchedKey = ref.child("watched").childByAutoId().key
        self.watchListKey = ref.child("watchList").childByAutoId().key
        self.watchingNowKey = ref.child("watchingNow").childByAutoId().key
    }
    
    init(snapshot: DataSnapshot){
        let value = snapshot.value as! NSDictionary
        
        self.userId = value["uid"] as! String
        self.facebookId = value["facebookId"] as? String
        self.email = value["email"] as? String
        self.displayName = value["displayName"] as? String
        self.watchedKey = value["watchedKey"] as? String
        self.watchListKey = value["watchListKey"] as? String
        self.watchingNowKey = value["watchingNowKey"] as? String
        self.photoURL = URL(string: (value["photoURL"] as? String)!)
    }
    
    func toDictionary() -> NSDictionary {
        return [
            "uid": userId,
            "facebookId": facebookId,
            "email": email,
            "displayName": displayName,
            "watchedKey": watchedKey,
            "watchListKey": watchListKey,
            "watchingNowKey": watchingNowKey,
            "photoURL": photoURL?.absoluteString
            
        ]
    }
}
