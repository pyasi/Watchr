//
//  LogInViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 7/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton.delegate = self
        
        //debugLogout()
        // Do any additional setup after loading the view.
    }
    
    func debugLogout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.authListener = Auth.auth().addStateDidChangeListener() { (auth, user) in
            
            if let user = user {
                if currentUser == nil{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()){
                            currentUser = AppUser.init(snapshot: snapshot)
                            ref.child("favorites").child(currentUser!.favoritesKey!).observeSingleEvent(of: .value, with: {
                                (snapshot) in
                                for child in snapshot.children{
                                    let thisChild = child as! DataSnapshot
                                    favorites.append(thisChild.value as! Int)
                                }
                                print("Favorites: ", favorites)
                            })
                        }
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                print("User is signed in with uid:", user.uid)
                print("User is ", user.displayName)
                self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else{
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(user!.uid){
                        print("User Exists")
                    }else{
                        self.createUser(user: user)
                    }
                })
                
                if let error = error {
                    return
                }
            }
        }
    }
    
    func createUser(user: User?){
        let newUser = AppUser(user: user!)
        currentUser = newUser
        ref.child("users").child(user!.uid).setValue(newUser.toDictionary())
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
}


