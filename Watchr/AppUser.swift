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
    var favoritesKey: String?
    
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
        self.favoritesKey = ref.child("favorites").childByAutoId().key
    }
    
    init(snapshot: DataSnapshot){
        let value = snapshot.value as! NSDictionary
        
        self.userId = value["uid"] as! String
        self.email = value["email"] as? String
        self.displayName = value["displayName"] as? String
        self.favoritesKey = value["favoritesKey"] as? String
    }
    
    func toDictionary() -> NSDictionary {
        return [
            "uid": userId,
            "email": email,
            "displayName": displayName,
            "favoritesKey": favoritesKey
        ]
    }
}
