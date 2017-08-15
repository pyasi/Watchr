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

protocol InitialLoadingProtocol : NSObjectProtocol {
    var hasLoadedWatched: Bool  { get set }
    var hasLoadedWatchList: Bool  { get set }
    var hasLoadedWatchingNow: Bool  { get set }
    func shouldLoadViews() -> Bool
}

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate, InitialLoadingProtocol {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    var authListener: AuthStateDidChangeListenerHandle?
    var hasLoadedWatched: Bool = false
    var hasLoadedWatchList: Bool = false
    var hasLoadedWatchingNow: Bool = false
    
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
                            
                            
                            // TODO Clean up this logic
                            ref.child("watched").child(currentUser!.watchedKey!).observeSingleEvent(of: .value, with: {
                                (snapshot) in
                                for child in snapshot.children{
                                    let thisChild = child as! DataSnapshot
                                    currentUser?.watched.append(thisChild.value as! Int)
                                }
                                self.hasLoadedWatched = true
                            })
                            
                            ref.child("watchList").child(currentUser!.watchListKey!).observeSingleEvent(of: .value, with: {
                                (snapshot) in
                                for child in snapshot.children{
                                    let thisChild = child as! DataSnapshot
                                    currentUser?.watchList.append(thisChild.value as! Int)
                                }
                                self.hasLoadedWatchList = true
                            })
                            
                            ref.child("watchingNow").child(currentUser!.watchingNowKey!).observeSingleEvent(of: .value, with: {
                                (snapshot) in
                                for child in snapshot.children{
                                    let thisChild = child as! DataSnapshot
                                    currentUser?.watching.append(thisChild.value as! Int)
                                }
                                self.hasLoadedWatchingNow = true
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
    
    func shouldLoadViews() -> Bool{
        if (hasLoadedWatched && hasLoadedWatchList && hasLoadedWatchingNow){
            return true
        }
        return false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabVC = segue.destination as? UITabBarController{
            if let navVC = tabVC.viewControllers?[0] as? UINavigationController{
                if let destinationVC = navVC.viewControllers[0] as? MainViewController{
                    
                    //destinationVC.initialLoadDelegate = self
                }
            }
        }
    }
}


