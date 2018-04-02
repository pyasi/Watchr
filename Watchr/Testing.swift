//
//  Testing.swift
//  Watchr
//
//  Created by Peter Yasi on 8/31/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class Testing{
    
    func getFriendsWithApp(){
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start { (connection, result , error) -> Void in
            
            if error != nil {
                print(error!)
            }
            else {
                print(result!)
                //Do further work with response
            }
        }
    }
    
    func getFriendsWithoutApp(){
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start { (connection, result , error) -> Void in
            
            if error != nil {
                print(error!)
            }
            else {
                print(result!)
                //Do further work with response
            }
        }
    }
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            let friend = Friend()
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                let userData = result as! NSDictionary
                friend.userId = userData.value(forKey: "id") as! String
                
                if let userName = userData.value(forKey: "name") as? String
                {
                    friend.name = userName
                }
                
                if let profilePictureObj = userData.value(forKey: "picture") as? NSDictionary
                {
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                    friend.photoUrl  = data.value(forKey: "url") as! String
                }
                print(friend)
            }
        })
    }
}
