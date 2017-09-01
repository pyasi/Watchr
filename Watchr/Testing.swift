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
}
