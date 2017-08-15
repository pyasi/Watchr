//
//  ProfileMainViewController.swift
//  Watchr
//
//  Created by Peter Yasi on 8/14/17.
//  Copyright © 2017 Peter Yasi. All rights reserved.
//

import UIKit

class ProfileMainViewController: UIViewController {

    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadProfileInformation()
    }
    
    func loadProfileInformation(){
        let url = URL(string: "http://graph.facebook.com/\(String(describing: currentUser?.userId))/picture?type=large")
        profilePhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "profile"))
        displayNameLabel.text = currentUser?.displayName
        
        //profilePhoto.layer.cornerRadius =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
