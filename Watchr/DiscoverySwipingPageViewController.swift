//
//  DiscoverySwipingPageViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/9/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import AMScrollingNavbar

class DiscoverySwipingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UISearchBarDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let popularShows = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        let topRatedShows = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        let airingTonight = storyboard?.instantiateViewController(withIdentifier: "PopularShowsId") as! ShowCollectionViewController
        
        popularShows.showListType = ShowListType.Popular
        topRatedShows.showListType = ShowListType.TopRated
        airingTonight.showListType = ShowListType.OnTheAir
        
        pages.append(popularShows)
        pages.append(topRatedShows)
        pages.append(airingTonight)
        
        setViewControllers([popularShows], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search shows"
        searchBar.delegate = self
        searchBar.barStyle = UIBarStyle.black
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchBar.tag = 5
        
        self.navigationItem.titleView = searchBar
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
}
