//
//  MainViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import AMScrollingNavbar

enum ShowListType {
    case Popular
    case TopRated
    case OnTheAir
    case Recommended
}

class MainViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var containerView: UIView!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(containerView, delay: 50.0)
        }
        
    }
    
    // Nav Bar
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }

    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.performSegue(withIdentifier: "LogOutSegue", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension UISearchBar {
    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}
