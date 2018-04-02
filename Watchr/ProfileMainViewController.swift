//
//  ProfileMainViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import TMDBSwift
import PageMenu

class ProfileMainViewController: UIViewController {

    @IBOutlet var profileDetailsView: UIView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var viewToSizeContainer: UIView!
    @IBOutlet var numberOfFollowersLabel: UILabel!
    @IBOutlet var numberFollowingLabel: UILabel!
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadProfileInformation()
        loadPagingController()
    }
    
    func loadProfileInformation(){
        let url = currentUser?.photoURL
        profilePhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "profile"))
        displayNameLabel.text = currentUser?.displayName
        
        followButton.layer.borderColor = hexStringToUIColor(hex: "6058FF").cgColor
        followButton.layer.borderWidth = 0.5
        followButton.layer.cornerRadius = 3
        
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderWidth = 0.0
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height / 2
        profilePhoto.clipsToBounds = true
    }
    
    func loadPagingController(){
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let watchedController = storyboard?.instantiateViewController(withIdentifier: "ProfileShowStoryboardId") as! ProfileShowsListViewController
        watchedController.title = "Watched"
        watchedController.showStatus = WatchrShowStatus.Watched
        controllerArray.append(watchedController)
        
        let watchingController = storyboard?.instantiateViewController(withIdentifier: "ProfileShowStoryboardId") as! ProfileShowsListViewController
        watchingController.title = "Watching"
        watchingController.showStatus = WatchrShowStatus.Watching
        controllerArray.append(watchingController)
        
        let watchListController = storyboard?.instantiateViewController(withIdentifier: "ProfileShowStoryboardId") as! ProfileShowsListViewController
        watchListController.title = "Watch List"
        watchListController.showStatus = WatchrShowStatus.WatchList
        controllerArray.append(watchListController)
        
        let parameters: [CAPSPageMenuOption] = [
            .centerMenuItems(false),
            .menuItemWidth(75.0),
            .viewBackgroundColor(darkTheme),
            .scrollMenuBackgroundColor(mediumTheme),
            .scrollAnimationDurationOnMenuItemTap(250),
            .addBottomMenuHairline(false),
            .selectionIndicatorHeight(2.0)
        ]
                
        let rect = CGRect(x: 0, y: profileDetailsView.frame.height, width: viewToSizeContainer.frame.width, height: viewToSizeContainer.frame.height)
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        //let verticalConstraint = NSLayoutConstraint(item: pageMenu?.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: profileDetailsView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        //pageMenu!.view.addConstraints([verticalConstraint])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
