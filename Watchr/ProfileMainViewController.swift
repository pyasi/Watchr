//
//  ProfileMainViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit
import PageMenu

class ProfileMainViewController: UIViewController {

    @IBOutlet var profileDetailsView: UIView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadProfileInformation()
        loadPagingController()
    }
    
    func loadProfileInformation(){
        let url = URL(string: "http://graph.facebook.com/\(String(describing: currentUser?.userId))/picture?type=large")
        profilePhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "profile"))
        displayNameLabel.text = currentUser?.displayName
        
        //profilePhoto.layer.cornerRadius =
    }
    
    func loadPagingController(){
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let controller = storyboard?.instantiateViewController(withIdentifier: "testing") as! ShowCollectionViewController
        controller.title = "Popular"
        controller.showListType = ShowListType.Popular
        controllerArray.append(controller)
        
        let controller2 = storyboard?.instantiateViewController(withIdentifier: "testing") as! ShowCollectionViewController
        controller2.title = "Other"
        controller2.showListType = ShowListType.Popular
        controllerArray.append(controller2)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let backgroundColor = hexStringToUIColor(hex: "16171C")
        let selectionColor = hexStringToUIColor(hex: "1E242E")
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.0),
            .menuItemSeparatorWidth(0.0),
            .viewBackgroundColor(backgroundColor),
            .scrollMenuBackgroundColor(selectionColor),
            .scrollAnimationDurationOnMenuItemTap(250),
            .menuItemFont(UIFont(name: "Silom", size: 15)!)
            ]
        
        let rect = CGRect(x: 0, y: profileDetailsView.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
