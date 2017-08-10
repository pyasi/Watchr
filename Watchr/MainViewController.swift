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
}

class MainViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var containerView: UIView!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(containerView, delay: 50.0)
        }
        
        setupNavBar()
    }
    
    func setupNavBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search shows"
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.black
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchBar.tag = 5
        
        let navBar = self.navigationController?.navigationBar
        
        let firstFrame = CGRect(x: 0, y: 0, width: (navBar?.frame.width)!/2, height: (navBar?.frame.height)!)
        let secondFrame = CGRect(x: (navBar?.frame.width)!/2, y: 0, width: (navBar?.frame.width)!/2, height: (navBar?.frame.height)!)
        
        let firstLabel = UILabel(frame: firstFrame)
        firstLabel.text = "First"
        
        let secondLabel = UILabel(frame: secondFrame)
        secondLabel.text = "Second"
        
        navBar?.addSubview(firstLabel)
        navBar?.addSubview(secondLabel)
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = searchBar.text != "" ? true : false
        if (!isSearching){
            searchBar.showsCancelButton = false
            //self.popularShowsCollectionView.reloadData()
        }
        shouldShowBlur(shouldShow: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shouldShowBlur(shouldShow: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if (!searchBar.text!.isEmpty){
            shouldShowBlur(shouldShow: false)
            //popularShowsCollectionView.setContentOffset(CGPoint.zero, animated: false)
            //searchForShowsWithQuery(query: searchBar.text!)
        }
        else{
            shouldShowBlur(shouldShow: true)
            /*
             ***
             Collection view empty state
             ***
             */
        }
    }
    
    func shouldShowBlur(shouldShow: Bool){
        if(shouldShow){
            //popularShowsCollectionView.addSubview(darkenedView)
        }
        else{
            //darkenedView.removeFromSuperview()
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
