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
import PageMenu
import TMDBSwift

enum ShowListType {
    case Popular
    case TopRated
    case OnTheAir
    case Recommended
}

class MainViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var containerView: UIView!
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Discovery"
        
        
        loadPagingController()
    }
    
    
    func loadPagingController(){
        
        let popularShows = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        let topRatedShows = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        let onTheAir = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        let recommendedShows = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        
        popularShows.showListType = ShowListType.Popular
        topRatedShows.showListType = ShowListType.TopRated
        onTheAir.showListType = ShowListType.OnTheAir
        //recommendedShows.showListType = ShowListType.Recommended
        
        popularShows.title = "Popular"
        topRatedShows.title = "Top Rated"
        onTheAir.title = "On the Air"
        recommendedShows.title = "For You"
        
        controllerArray.append(popularShows)
        controllerArray.append(topRatedShows)
        controllerArray.append(onTheAir)
        //controllerArray.append(recommendedShows)
        
        let parameters: [CAPSPageMenuOption] = [
            .centerMenuItems(true),
            .menuItemWidth(90.0),
            .menuMargin(18.0),
            .viewBackgroundColor(darkTheme),
            .scrollMenuBackgroundColor(mediumTheme),
            .scrollAnimationDurationOnMenuItemTap(250),
            .addBottomMenuHairline(false),
            .selectionIndicatorHeight(2.0),
            .enableHorizontalBounce(false)
        ]
        
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
    }
    
    // Nav Bar
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
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
